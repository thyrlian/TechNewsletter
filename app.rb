require './lib/newsletter.rb'

include Newsletter

factory = Factory.run(:inline_css => false)

spec = Parser.analyze('example.slm'){}.spec

spec.iterate do |key, value|
  factory.print(key, value)
end

factory.finish
