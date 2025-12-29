# A Project is a template for a website made in Flora.
#
# Projects live in a directory and have:
#  1) Blueprints, files that can be transformed into another file type (like HTML).
#  2) Supporting Code, Ruby code that lives in lib/ that Blueprints can depend on.
class Flora::Project

  attr_reader(:dir, :blueprints)

  IGNORES = ['.git/*', 'lib/**', '**_*.rb']


  def initialize(dir, config)
    @dir = dir
    @config = config

    @blueprints = find_blueprints

    @loader = Zeitwerk::Loader.new
    if has_supporting_code?
      @loader.push_dir(@dir.join('lib').to_s)
    end
    @loader.enable_reloading
    @loader.setup
    @loader.eager_load
  end


  def reload
    @loader.reload
    @blueprints = find_blueprints
  end


  private

    def find_blueprints
      blueprints = []

      @dir.find do |file|
        next if IGNORES.any? { file.fnmatch((@dir / it).to_s) }
        next if file.directory?

        klass = Blueprint.types.find {
          it.recognize(file.relative_path_from(@dir), @config)
        }

        next unless klass

        blueprints << klass.new(file, self)
      end

      blueprints
    end


    def has_supporting_code?
      @dir.join('lib').exist?
    end

end
