class Flora::Project::Blueprint::RubyHtml < Flora::Project::Blueprint

  include Flora::Project::Blueprint::HasLayout


  def self.recognize(file, config)
    file.extname == '.rb'
  end


  private

    def render_lilac
      instance_eval(@file.read, @file.to_s)
    end

end
