module Shoperb module Theme module Liquid module Filter
  module ThemeStyles

    def customize(asset_path, settings_drop)
      compiler(settings).compiled_source(cleaned_file_path)
      Theme.current.preview_assets.find_by(
        file: asset_path
      ).customize(settings_drop)
    end
  end
end end end end
