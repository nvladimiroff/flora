module TestPlugin

  module FactoryMethods

    def assemble(out_dir)
      super

      out_dir.join('plugin.html').write('Hello plugin')
    end

  end

end
