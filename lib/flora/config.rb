# This is the user-visible configuration class. It lives in ROOT/_config.rb.
class Flora::Config

  def initialize(file, flora)
    @file = file
    @flora = flora
    load if @file.exist?
  end


  def use(mod)
    @flora.load_plugin(mod)
  end


  def extend_view(mod)
    Kernel.prepend(mod)
  end


  private

    def load
      instance_eval(@file.read)
    end

end
