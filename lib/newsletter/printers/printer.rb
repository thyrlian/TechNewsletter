module Newsletter
  class Printer
    class << self
      def print(doc, node)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end
    end

    private_class_method :new
  end
end
