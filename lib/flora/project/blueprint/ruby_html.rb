class Flora::Project::Blueprint::RubyHtml < Flora::Project::Blueprint

  include Flora::Project::Blueprint::Nestable


  def self.recognize(file, config)
    file.extname == '.rb'
  end


  private

    def render_lilac
      instance_eval(@file.read)
    end

end
