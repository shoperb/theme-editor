class SearchDrop < Liquid::Drop
  attr_accessor :search, :options, :word

  def initialize(word = "")
    @word = word
    @options = {}
    @search = word.present? ? elastic(word) : nil
  end

  def elastic(word)
    @search = Tire::Search::Search.new(Product.table_name, load: true)
    @search.query do
      boolean(minimum_number_should_match: 1) do
        should { string word }
        must { term :shop_id, Shop.current.id }
        must { term :active, true }
      end
    end
    #Product.search(load: true) do


    #sort { by options[:sort], 'asc' } if options[:sort]
    #page = (options[:page] || 1).to_i
    #search_size = options[:per] || 25
    #from (page-1) * search_size
    #size search_size

    #facet 'global-tags', :global => true do
    #  terms :tags
    #end
    #end
  end

  def paginate(page = 1, search_size = 25)
    page &&= page.to_i
    search_size &&= search_size.to_i

    @search.from (page-1) * search_size
    @search.size search_size
    self
  end

  def performed
    search && search.response.success?
  end

  def terms
    word
  end

  def results
    search.respond_to?(:results) ? search.results : []
  end

  alias_method :collection, :results
  delegate :any?, to: :results
  delegate :each, to: :results
  delegate :map, to: :results

  def to_s
    "#<Search terms: '#{terms}', executed: #{performed}>"
  end

  def inspect
    to_s
  end

  def to_curl
    search.respond_to?(:to_curl) ? search.to_curl : search.to_s
  end

end