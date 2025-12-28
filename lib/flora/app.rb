require 'rack'

class Flora::App

  # TODO: make this support multiple apps.
  OUT_DIR = '/tmp/flora/'


  class Rebuilder

    def initialize(app, dir, flora)
      @app = app
      @dir = Pathname.new(dir)
      @flora = flora
      @last_built = Time.at(0)
    end


    def call(env)
      if should_rebuild?
        @flora.build(OUT_DIR)
        @last_built = Time.now.utc
        # TODO: also trigger a reload in the browser
      end

      @app.call(env)
    end


    private

      def should_rebuild?
        # TODO: this is probably slow. I'm sure there's an easier kqueue-esq way
        # of doing this.
        @dir.find do |file|
          return true if file.stat.mtime > @last_built
        end

        false
      end

  end


  class Reloader

    def initialize(app, flora)
      @app = app
      @flora = flora
    end

    def call(env)
      @flora.reload_blueprint

      @app.call(env)
    end

  end


  # UGLY. Is there a better way to do this?
  class StaticWithoutHtml

    def initialize(app, dir)
      @app = app
      @dir = Pathname.new(dir)
    end

    def call(env)
      # /about -> about.html
      html_file = @dir.join(env['REQUEST_PATH'][1..] + '.html')
      if html_file.exist?
        [200, {'Content-Type' => 'text/html'}, [html_file.read]]
      else
        @app.call(env)
      end
    end

  end


  def self.app(path)
    flora = Flora.new(path)

    Rack::Builder.new do
      use Rebuilder, path, flora
      use Reloader, flora
      use StaticWithoutHtml, OUT_DIR
      use Rack::Static, urls: [''], root: OUT_DIR, index: 'index.html'

      map "/" do
        run ->(env) do
          [404, {'Content-Type' => 'text/plain'}, ['Page Not Found!']]
        end
      end
    end
  end

end
