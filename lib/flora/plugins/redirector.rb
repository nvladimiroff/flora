module Flora::Plugins::Redirector

  module FactoryMethods

    def assemble(out_dir)
      super

      @config.redirects.each do |src, dest|
        out_filename = out_dir.join(src + '.html')
        out_filename.dirname.mkdir unless out_filename.dirname.exist?
        out_filename.write(build_redir_file(dest))
      end
    end


    def build_redir_file(url)
      <<~HTML
        <html>
          <head>
            <meta http-equiv="refresh" content="0; url=#{url}" />
          </head>
        </html>
      HTML
    end

  end


  module Config

    def self.included(base)
      base.class_eval do
        attr_accessor(:redirects)
      end
    end

  end

end
