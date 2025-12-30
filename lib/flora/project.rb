# A Project is a template for a website made in Flora.
#
# Projects live in a directory and have:
#  1) Blueprints, files that can be transformed into another file type (like HTML).
#  2) Supporting Code, Ruby code that lives in lib/ that Blueprints can depend on.
class Flora::Project

  attr_reader(:dir, :blueprints)

  IGNORES = ['.git/*', 'lib/**', '**_*.rb']

  def self.blueprint_classes
    @blueprint_classes ||= [Blueprint::Markdown, Blueprint::RubyHtml]
  end


  def initialize(dir, loader, config)
    @dir = dir
    @loader = loader
    @config = config
    @mutex = Mutex.new

    @blueprints = find_blueprints
  end


  def reload
    # `flora serve` can sometimes hit this multiple times and cause errors.
    @mutex.synchronize do
      @loader.reload
      @blueprints = find_blueprints
    end
  end


  private

    def find_blueprints
      blueprints = []

      @dir.find do |file|
        next if IGNORES.any? { file.fnmatch((@dir / it).to_s) }
        next if file.directory?

        klass = self.class.blueprint_classes.find {
          it.recognize(file.relative_path_from(@dir), @config)
        }

        next unless klass

        blueprints << klass.new(file, self)
      end

      blueprints
    end

end
