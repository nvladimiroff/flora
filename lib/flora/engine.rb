class Flora::Engine

  attr_reader(:out_dir)


  def initialize(path)
    @path = Pathname.new(path)
    @dsl = Html.new
  end


  def build(out_dir)
    @out_dir = Pathname.new(out_dir)

    body = @dsl.instance_eval(File.read(@path.join('index.rb')))
    builder = Nokogiri::HTML5::Builder.new do |html|
      to_html(body, html)
    end
    File.write(@out_dir.join('index.html'), builder.to_html)
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
