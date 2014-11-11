module Sprockets
  module Resolve
    # Public: Iterate over every file under all load paths.
    #
    # Returns Enumerator if no block is given.
    def each_file
      return to_enum(__method__) unless block_given?

      paths.each do |root|
        stat_tree(root).each do |filename, stat|
          if stat.file?
            yield filename
          end
        end
      end

      nil
    end

    # Finds the expanded real path for a given logical path by
    # searching the environment's paths.
    #
    #     resolve("application.js")
    #     # => "/path/to/app/javascripts/application.js.coffee"
    #
    # A `FileNotFound` exception is raised if the file does not exist.
    def resolve(path, options = {})
      resolve_all(path, options) do |filename|
        return filename
      end

      accept = options[:accept]
      message = "couldn't find file '#{path}'"
      message << " with type '#{accept}'" if accept
      raise FileNotFound, message
    end

    def resolve_in_load_path(load_path, logical_path, options = {})
      if !self.paths.include?(load_path.to_s)
        raise FileOutsidePaths, "#{load_path} isn't in paths: #{self.paths.join(', ')}"
      end

      resolve_all_under_load_path(load_path, logical_path, options) do |filename|
        return filename
      end

      accept = options[:accept]
      message = "couldn't find file '#{logical_path}' under '#{load_path}'"
      message << " with type '#{accept}'" if accept
      raise FileNotFound, message
    end

    def resolve_all_under_load_path(load_path, logical_path, options = {}, &block)
      return to_enum(__method__, load_path, logical_path, options) unless block_given?

      logical_name, mime_type, _ = parse_path_extnames(logical_path)
      logical_basename = File.basename(logical_name)

      accepts = parse_accept_options(mime_type, options[:accept])

      _resolve_all_under_load_path(load_path, logical_name, logical_basename, accepts, &block)

      nil
    end

    # Public: Finds the expanded real path for a given logical path by searching
    # the environment's paths. Includes all matching paths including fallbacks
    # and shadowed matches.
    #
    #     resolve_all("application.js").first
    #     # => "/path/to/app/javascripts/application.js.coffee"
    #
    # `resolve_all` returns an `Enumerator`. This allows you to filter your
    # matches by any condition.
    #
    #     resolve_all("application").find do |path|
    #       mime_type_for(path) == "text/css"
    #     end
    #
    def resolve_all(path, options = {}, &block)
      return to_enum(__method__, path, options) unless block_given?
      path = path.to_s

      logical_name, mime_type, _ = parse_path_extnames(path)
      logical_basename = File.basename(logical_name)

      accepts = parse_accept_options(mime_type, options[:accept])

      self.paths.each do |load_path|
        _resolve_all_under_load_path(load_path, logical_name, logical_basename, accepts, &block)
      end

      nil
    end

    # Experimental: Get transform type for filename
    def resolve_path_transform_type(filename, accept)
      mime_type = parse_path_extnames(filename)[1]
      resolve_transform_type(mime_type, accept)
    end

    # Experimental
    def resolve_asset_uri(path, options = {})
      path = path.to_s
      accept = options[:accept]
      skip_bundle = options.key?(:bundle) ? !options[:bundle] : false

      available_encodings = self.encodings.keys + ['identity']
      encoding = find_best_q_match(options[:accept_encoding], available_encodings)

      if absolute_path?(path)
        path = File.expand_path(path)
        if file?(path) && (accept.nil? || resolve_path_transform_type(path, accept))
          filename = path
          type = resolve_path_transform_type(path, accept)
        end
      else
        if filename = resolve_all(path, accept: accept).first
          mime_type = parse_path_extnames(path)[1]
          accept = parse_accept_options(mime_type, accept).map { |t, v| "#{t}; q=#{v}" }.join(", ")
          type = resolve_path_transform_type(filename, accept)
        end
      end

      if filename
        encoding = nil if encoding == 'identity'
        AssetURI.build(filename, type: type, skip_bundle: skip_bundle, encoding: encoding)
      end
    end

    # Public: Enumerate over all logical paths in the environment.
    #
    # Returns an Enumerator of [logical_path, filename].
    def logical_paths
      return to_enum(__method__) unless block_given?

      seen = Set.new

      self.paths.each do |load_path|
        stat_tree(load_path).each do |filename, stat|
          next unless stat.file?

          path = split_subpath(load_path, filename)
          path, mime_type, _ = parse_path_extnames(path)
          path = normalize_logical_path(path)
          path += mime_types[mime_type][:extensions].first if mime_type

          if !seen.include?(path)
            yield path, filename
            seen << path
          end
        end
      end

      nil
    end

    # Deprecated: Iterate over all logical paths with a matcher.
    #
    # Remove from 4.x.
    #
    # args - List of matcher objects.
    #
    # Returns Enumerator if no block is given.
    def each_logical_path(*args, &block)
      return to_enum(__method__, *args) unless block_given?

      filters = args.flatten.map { |arg| Manifest.compile_match_filter(arg) }
      logical_paths.each do |a, b|
        if filters.any? { |f| f.call(a, b) }
          if block.arity == 2
            yield a, b
          else
            yield a
          end
        end
      end

      nil
    end

    protected
      def parse_accept_options(mime_type, types)
        accepts = []
        accepts += parse_q_values(types) if types

        if mime_type
          if accepts.empty? || accepts.any? { |accept, _| match_mime_type?(mime_type, accept) }
            accepts.unshift([mime_type, 1.0])
          else
            return []
          end
        end

        if accepts.empty?
          accepts << ['*/*', 1.0]
        end

        accepts
      end

      def normalize_logical_path(path)
        dirname, basename = File.split(path)
        path = dirname if basename == 'index'
        path
      end

      def _resolve_all_under_load_path(load_path, logical_name, logical_basename, accepts, &block)
        filenames = path_matches(load_path, logical_name, logical_basename)

        matches = []

        # TODO: Cleanup double iteration of accept and filenames

        # Exact mime type match first
        matches += find_q_matches(accepts, filenames) do |filename, accepted|
          if !file?(filename)
            nil
          elsif accepted == '*/*'
            filename
          elsif parse_path_extnames(filename)[1] == accepted
            filename
          end
        end

        # Then transformable match
        matches += find_q_matches(accepts, filenames) do |filename, accepted|
          if !file?(filename)
            nil
          elsif accepted == '*/*'
            filename
          elsif resolve_path_transform_type(filename, accepted)
            filename
          end
        end

        matches.uniq.each(&block)
      end

      def path_matches(load_path, logical_name, logical_basename)
        filenames = []
        dirname = File.dirname(File.join(load_path, logical_name))
        dirname_matches(dirname, logical_basename) { |fn| filenames << fn }
        resolve_alternates(load_path, logical_name) { |fn| filenames << fn }
        dirname_matches(File.join(load_path, logical_name), "index") { |fn| filenames << fn }
        filenames
      end

      def dirname_matches(dirname, basename)
        self.entries(dirname).each do |entry|
          name = parse_path_extnames(entry)[0]
          if basename == name
            yield File.join(dirname, entry)
          end
        end
      end

      def resolve_alternates(load_path, logical_name)
      end

      # Internal: Returns the name, mime type and `Array` of engine extensions.
      #
      #     "foo.js.coffee.erb"
      #     # => ["foo", "application/javascript", [".coffee", ".erb"]]
      #
      def parse_path_extnames(path)
        mime_type       = nil
        engine_extnames = []
        len = path.length

        path_extnames(path).reverse_each do |extname|
          if engines.key?(extname)
            mime_type = engine_mime_types[extname]
            engine_extnames.unshift(extname)
            len -= extname.length
          elsif mime_exts.key?(extname)
            mime_type = mime_exts[extname]
            len -= extname.length
            break
          else
            break
          end
        end

        name = path[0, len]
        return [name, mime_type, engine_extnames]
      end
  end
end
