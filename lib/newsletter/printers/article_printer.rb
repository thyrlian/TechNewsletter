module Newsletter
  class ArticlePrinter < Printer
    class << self
      def print(doc, node)
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
        fragment_article = MLParserWrapper.parse_fragment('article.html')
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
        doc.at('#content').add_child(fragment_article)
      end
    end
  end
end
