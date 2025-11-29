require 'rack'

class Flora::App

  def self.app(path)
    flora = Flora::Engine.new(path, '/tmp/flora/')
    flora.build

    Rack::Builder.new do
      use Rack::Static, urls: [''], root: flora.out_dir.to_s, index: 'index.html'
      map "/" do
        run ->(env) do
          [404, {'Content-Type' => 'text/plain'}, ['Page Not Found!']]
        end
      end
    end
  end

end
