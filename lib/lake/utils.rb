module Lake
  module Utils
    def lake_root
      File.expand_path("../..",__FILE__)
    end
    module_function :lake_root
  end
end
