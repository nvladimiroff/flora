module Flora::Plugins::StaticFiles

  class StaticFile < Flora::Project::Blueprint

    def self.recognize(file, config)
      file.fnmatch?(config.static_files_dir + '/**')
    end


    def render
      @file.read
    end


    def page_name
      @file.relative_path_from(@project.dir).to_s
    end

  end


  module ConfigMethods

    def self.included(base)
      base.class_eval do
        attr_accessor(:static_files_dir)
      end
    end

  end

end
