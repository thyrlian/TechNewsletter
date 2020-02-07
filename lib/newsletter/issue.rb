module Newsletter
  class Issue
    attr_accessor :name, :date, :masthead, :article, :imprint

    class << self
      def create()
        new()
      end
    end

    def method_missing(name, *args, &block)
      match_data = /^add_(\w+)/.match(name.to_s)
      if match_data
        field = match_data[1]
        puts field
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      /^add_(\w+)/.match(name.to_s) or super
    end
  end
end
