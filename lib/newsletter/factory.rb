require 'nokogiri'

module Newsletter
  class Factory
    @@directory = 'templates/'

    def initialize
      @doc = parse_html('base.html')
    end

    def parse_html(filename)
      File.open(@@directory + filename) { |f| Nokogiri::HTML(f) }
    end

    def parse_fragment(filename)
      Nokogiri::HTML::DocumentFragment.parse(File.read(@@directory + filename))
    end

    def finish(output = 'newsletter.html')
      puts "⚡ Generating #{output}..."
      xsl = Nokogiri::XSLT(File.read(@@directory + 'pretty-printer.xsl'))
      File.write(output, xsl.apply_to(@doc))
    end

    class << self
      def run
        new()
      end
    end

    def method_missing(name, *args, &block)
      match_data = /^print_(\w+)/.match(name.to_s)
      if match_data
        field = match_data[1]
        puts "⚠ Don't know how to print #{field}, please implement it!"
      end
      super
    end

    def print_masthead(img_url)
      fragment_masthead = parse_fragment('masthead.html')
      fragment_masthead.css('#masthead > a > img').first['src'] = img_url
      @doc.at('body').add_child(fragment_masthead)
    end

    private :parse_html, :parse_fragment
    private_class_method :new
  end
end
