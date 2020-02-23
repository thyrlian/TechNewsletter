require './lib/newsletter.rb'

include Newsletter

factory = Factory.run

spec = Parser.analyze('example.slm'){}.spec

spec.iterate do |key, value|
  if Factory.supported_print_methods.include?(key.downcase.gsub(/\d+$/, ''))
    factory.send("print_#{key}", value)
  end
end

factory.finish
