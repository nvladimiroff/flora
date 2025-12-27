require 'rack'

class Flora::App

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
    # TODO: rebuild every req?
    flora.build('/tmp/flora/')

    Rack::Builder.new do
      use StaticWithoutHtml, '/tmp/flora'
      use Rack::Static, urls: [''], root: '/tmp/flora', index: 'index.html'
      map "/" do
        run ->(env) do
          [404, {'Content-Type' => 'text/plain'}, ['Page Not Found!']]
        end
      end
    end
  end

end
