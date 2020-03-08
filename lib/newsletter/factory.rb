require 'nokogiri'
require 'premailer'

module Newsletter
  class Factory
    @@directory = 'templates/'

    def initialize(params = {})
      @doc = parse_html('base.html')
      @inline_css = params.fetch(:inline_css, true)
    end

    def parse_html(filename)
      File.open(@@directory + filename) { |f| Nokogiri::HTML(f) }
    end

    def parse_fragment(filename)
      Nokogiri::HTML::DocumentFragment.parse(File.read(@@directory + filename))
    end

    def print(component, content)
      name = component.gsub(/\d+$/, '')
      name_intern = name.downcase
      if self.class.supported_print_methods.include?(name_intern)
        method = "print_#{name_intern}"
        puts "✎ Printing #{name}..."
        send(method, content)
      end
    end

    def apply_inline_css(html)
      puts "⚘ Applying inline CSS..."
      premailer = Premailer.new(html, :warn_level => Premailer::Warnings::SAFE)
      File.open(html, "w") do |f|
        f.puts premailer.to_inline_css
      end
    end

    def finish(output = 'newsletter.html')
      puts "⚡ Generating #{output}..."
      xsl = Nokogiri::XSLT(File.read(@@directory + 'pretty-printer.xsl'))
      File.write(output, xsl.apply_to(@doc))
      apply_inline_css(output) if @inline_css
      puts '☺ Done!'
    end

    class << self
      def run(params = {})
        new(params)
      end

      def supported_print_methods
        return self.private_instance_methods.grep(/print_\w+/).map { |m| m.to_s.gsub(/print_/, '') }
      end
    end

    # Below private methods are all for adding HTML content
    private

    def print_masthead(node)
      link = node[:children]['Link'][:data]
      img_url = node[:children]['Image'][:data]
      fragment_masthead = parse_fragment('masthead.html')
      fragment_masthead.css('#masthead > a').first['href'] = link
      fragment_masthead.css('#masthead > a > img').first['src'] = img_url
      @doc.at('body').add_child(fragment_masthead)
    end

    def print_content(node)
      fragment_content = parse_fragment('content.html')
      @doc.at('#masthead').add_next_sibling(fragment_content)
    end

    def print_article(node)
      title = node[:children]['Title'][:data]
      author = node[:children]['Author'][:data]
      author_tree = node[:children]['Author'][:children]
      author_avatar = nil
      author_link = nil
      if author_tree.keys.include?('Avatar')
        author_avatar = author_tree['Avatar'][:data]
      elsif author_tree.keys.include?('Gravatar')
        author_avatar = Gravatar.get_image_url(author_tree['Gravatar'][:data], 200)
      end
      if author_tree.keys.include?('Link')
        author_link = author_tree['Link'][:data]
      end
      outline = node[:children]['Outline'][:data]
      read_more = node[:children]['ReadMore'][:data]
      fragment_article = parse_fragment('article.html')
      fragment_article.css('.title > span').first.content = title
      fragment_article.css('.author > span').first.content = author
      fragment_article.css('.outline > p').first.content = outline
      fragment_article.css('.cta-read-more-button > a').first['href'] = read_more
      if author_avatar.nil?
        fragment_article.css('.author > img').remove
      else
        fragment_article.css('.author > img').first['src'] = author_avatar
      end
      unless author_link.nil?
        author_element = fragment_article.css('.author > span').first
        author_element.replace('<a>' + author_element.to_xml + '</a>')
        fragment_article.css('.author > a').first['href'] = author_link
        fragment_article.css('.author > a').first['style'] = 'text-decoration: none;'
      end
      @doc.at('#content').add_child(fragment_article)
    end

    def print_socialmedia(node)
      fragment_social_media_script = parse_fragment('social-media-script.html')
      @doc.at('head').add_child(fragment_social_media_script)
      fragment_social_media = parse_fragment('social-media.html')
      node[:children].each do |media, username|
        element = nil
        case media
        when "Twitter"
          element = %Q(<a href="https://twitter.com/#{username[:data]}"><i class="fab fa-twitter"> </i></a>)
        when "Facebook"
          element = %Q(<a href="https://www.facebook.com/#{username[:data]}"><i class="fab fa-facebook"> </i></a>)
        when "Instagram"
          element = %Q(<a href="https://www.instagram.com/#{username[:data]}"><i class="fab fa-instagram"> </i></a>)
        when "GitHub"
          element = %Q(<a href="https://github.com/#{username[:data]}"><i class="fab fa-github"> </i></a>)
        when "Medium"
          element = %Q(<a href="https://medium.com/@#{username[:data]}"><i class="fab fa-medium"> </i></a>)
        when "LinkedIn"
          element = %Q(<a href="https://www.linkedin.com/in/#{username[:data]}"><i class="fab fa-linkedin-in"> </i></a>)
        when "Link"
          element = %Q(<a href="#{username[:data]}"><i class="fas fa-link"> </i></a>)
        end
        unless element.nil?
          fragment_social_media.css('#social-media').first.add_child(element)
        end
      end
      @doc.at('#content').add_next_sibling(fragment_social_media)
    end

    def print_imprint(node)
      fragment_imprint = parse_fragment('imprint.html')
      if node[:data]
        fragment_imprint.css('#imprint').first.add_child("<span>#{node[:data]}</span>")
      elsif node[:children]
        imprints = []
        node[:children].each_value do |value|
          imprints.push(value[:data])
        end
        imprints.each do |i|
          fragment_imprint.css('#imprint').first.add_child("<span>#{i}</span>").first.add_next_sibling('<br/>')
        end
      end
      (@doc.at('#social-media') || @doc.at('#content')).add_next_sibling(fragment_imprint)
    end

    private :parse_html, :parse_fragment, :apply_inline_css
    private_class_method :new
  end
end
