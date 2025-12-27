require 'thor'

class Flora::Cli < Thor

  desc 'build OUT_DIR', 'Build a site'
  def build(out_dir)
    Flora.new('.').build(out_dir)
  end


  desc 'serve', 'Serve a site'
  def serve
    require 'puma'
    require 'puma/configuration'

    conf = Puma::Configuration.new do |user_config|
      user_config.log_requests(true)
      user_config.bind('tcp://localhost:3000')
      user_config.app(Flora::App.app('.'))
    end
    Puma::Launcher.new(conf, log_writer: Puma::LogWriter.stdio).run
  end

end
