module Flora::Plugins::StaticFiles

  class Copier

    def initialize(dir)
      @dir = dir
    end


    def copy_to(out)
      @dir.find do |public_file|
        next if public_file.directory?

        out_filename = out.join(Pathname.new(public_file).relative_path_from(@dir))
        out_filename.dirname.mkdir unless out_filename.dirname.exist?
        out_filename.write(File.read(public_file))
      end
    end

  end


  module BlueprintMethods

    def static_files_dir
      @dir.join(@config.static_files_dir || 'public')
    end

  end


  module FactoryMethods

    def assemble(out_dir)
      super

      static_out_dir = out_dir.join(@blueprint.static_files_dir.relative_path_from(@blueprint.dir))

      copier = Copier.new(@blueprint.static_files_dir)
      copier.copy_to(static_out_dir)
    end

  end


  module Config

    def self.included(base)
      base.class_eval do
        attr_accessor(:static_files_dir)
      end
    end

  end

end
