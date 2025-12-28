# This is the user-visible configuration class. It lives in ROOT/_config.rb.
class Flora::Config

  def initialize(file, flora)
    @file = file
    @flora = flora
    load if @file.exist?
  end


  def plugin(mod)
    @flora.load_plugin(mod)
  end


  private

    def load
      instance_eval(@file.read)
    end

end
