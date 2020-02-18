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
      match_data = /^print_([a-zA-Z]+)/.match(name.to_s)
      if match_data
        field = match_data[1].downcase
        method = "p_#{field}"
        if self.class.private_instance_methods.include?(method.intern)
          puts "✎ Printing #{match_data[1]}..."
          send(method, *args)
          return
        end
        puts "⚠ Don't know how to print #{field}, please implement it!"
      end
      super
    end

    private

    def p_masthead(node)
      link = node[:children]['Link'][:data]
      img_url = node[:children]['Image'][:data]
      fragment_masthead = parse_fragment('masthead.html')
      fragment_masthead.css('#masthead > a').first['href'] = link
      fragment_masthead.css('#masthead > a > img').first['src'] = img_url
      @doc.at('body').add_child(fragment_masthead)
    end

    def p_content(node)
      fragment_content = parse_fragment('content.html')
      @doc.at('#masthead').add_next_sibling(fragment_content)
    end

    def p_article(node)
      title = node[:children]['Title'][:data]
      author = node[:children]['Author'][:data]
      author_avatar = node[:children]['Author'][:children]['AuthorAvatar'][:data]
      outline = node[:children]['Outline'][:data]
      read_more = node[:children]['ReadMore'][:data]
      fragment_article = parse_fragment('article.html')
      fragment_article.css('.title > span').first.content = title
      fragment_article.css('.author > img').first['src'] = author_avatar
      fragment_article.css('.author > span').first.content = author
      fragment_article.css('.outline > p').first.content = outline
      fragment_article.css('.cta-read-more-button > a').first['href'] = read_more
      @doc.at('#content').add_child(fragment_article)
    end

    private :parse_html, :parse_fragment
    private_class_method :new
  end
end
