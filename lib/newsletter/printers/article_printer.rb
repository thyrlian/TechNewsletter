module Newsletter
  class ArticlePrinter < Printer
    class << self
      def print(doc, node)
        title = node[:children]['Title'][:data]
        author = node[:children].fetch('Author', {}).fetch(:data, nil)
        unless author.nil?
          author_tree = node[:children]['Author'][:children]
          author_avatar = nil
          author_link = nil
          unless author_tree.nil?
            if author_tree.keys.include?('Avatar')
              author_avatar = author_tree['Avatar'][:data]
            elsif author_tree.keys.include?('Gravatar')
              author_avatar = Gravatar.get_image_url(author_tree['Gravatar'][:data], 200)
            end
            if author_tree.keys.include?('Link')
              author_link = author_tree['Link'][:data]
            end
          end
        end
        outline = node[:children]['Outline'][:data]
        read_more = node[:children].fetch('ReadMore', {}).fetch(:data, nil)
        fragment_article = MLParserWrapper.parse_fragment('article.html')
        fragment_article.css('.title > span').first.content = title
        if author.nil?
          fragment_article.css('.author').remove
        else
          fragment_article.css('.author > span').first.content = author
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
        end
        fragment_article.css('.outline > p').first.content = outline
        if read_more.nil?
          fragment_article.css('.cta-read-more-button').remove
        else
          fragment_article.css('.cta-read-more-button > a').first['href'] = read_more
        end
        doc.at('#content').add_child(fragment_article)
      end
    end
  end
end
