module Newsletter
  class MastheadPrinter < Printer
    class << self
      def print(doc, node)
        link = node[:children]['Link'][:data]
        img_url = node[:children]['Image'][:data]
        fragment_masthead = self.parse_fragment('masthead.html')
        fragment_masthead.css('#masthead > a').first['href'] = link
        fragment_masthead.css('#masthead > a > img').first['src'] = img_url
        doc.at('body').add_child(fragment_masthead)
      end
    end
  end
end
