Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/*.rb').delete_if { |file| file.end_with?(File.basename(__FILE__)) }.each { |file| require file }
