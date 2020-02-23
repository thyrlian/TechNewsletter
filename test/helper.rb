$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), *%w(.. lib newsletter))))

require 'newsletter'
require 'minitest/autorun'

include Newsletter
