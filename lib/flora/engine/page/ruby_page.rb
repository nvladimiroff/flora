class Flora::Engine::Page::RubyPage < Flora::Engine::Page

  def render
    body = @dsl.instance_eval(@file.read)
    builder = Nokogiri::HTML5::Builder.new do |html|
      to_html(body, html)
    end
    builder.to_html
  end


  private

    def to_html(doc, html)
      return html.text(doc[:text]) if doc[:text]

      html.send(doc[:tag]) do
        doc[:children].each do |child|
          to_html(child, html)
        end
      end
    end

end
