require 'nokogiri'

module Newsletter
  class Printer
    class << self
      def print(doc, node)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end

      def parse_fragment(filename)
        Nokogiri::HTML::DocumentFragment.parse(File.read(Constants.templates_directory + filename))
      end
    end

    private_class_method :new
  end
end
