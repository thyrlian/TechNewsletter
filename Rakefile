$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), *%w(lib))))
require 'newsletter'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.warning = false
end

desc 'Run tests'
task default: :test
