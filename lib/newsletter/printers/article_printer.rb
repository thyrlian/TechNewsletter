require_relative 'printer'
require_relative '../ml_parser_wrapper'
require_relative '../plugins/gravatar'

module Newsletter
  class ArticlePrinter < Printer
    class << self
      def print(doc, node)
        title = node[:children]['Title'][:data]
        author, author_avatar, author_link = get_author(node)
        outline = node[:children]['Outline'][:data]
        read_more = node[:children].fetch('ReadMore', {}).fetch(:data, nil)
        fragment_article = MLParserWrapper.parse_fragment('article.html')
        fragment_article.css('.title > span').first.content = title
        put_author(fragment_article, author, author_avatar, author_link)
        fragment_article.css('.outline > p').first.content = outline
        put_read_more(fragment_article, read_more)
        doc.at('#content').add_child(fragment_article)
      end

      def get_author(node)
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
        return author, author_avatar, author_link
      end

      def put_author(fragment, author, author_avatar, author_link)
        if author.nil?
          fragment.css('.author').remove
        else
          fragment.css('.author > span').first.content = author
          if author_avatar.nil?
            fragment.css('.author > img').remove
          else
            fragment.css('.author > img').first['src'] = author_avatar
          end
          unless author_link.nil?
            author_element = fragment.css('.author > span').first
            author_element.replace('<a>' + author_element.to_xml + '</a>')
            fragment.css('.author > a').first['href'] = author_link
            fragment.css('.author > a').first['style'] = 'text-decoration: none;'
          end
        end
      end

      def put_read_more(fragment, read_more)
        if read_more.nil?
          fragment.css('.cta-read-more-button').remove
        else
          fragment.css('.cta-read-more-button > a').first['href'] = read_more
        end
      end
    end

    private_class_method :get_author, :put_author, :put_read_more
  end
end
