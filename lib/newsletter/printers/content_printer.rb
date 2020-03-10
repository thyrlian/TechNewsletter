module Newsletter
  class ContentPrinter < Printer
    class << self
      def print(doc, node)
        fragment_content = MLParserWrapper.parse_fragment('content.html')
        doc.at('#masthead').add_next_sibling(fragment_content)
      end
    end
  end
end
