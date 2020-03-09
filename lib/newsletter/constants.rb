module Newsletter
  class Constants
    @templates_directory = 'templates/'

    class << self
      attr_reader :templates_directory
    end

    private_class_method :new
  end
end
