require 'rubygems'
require 'fileutils'

class Files
  def self.create(options = {})
		FileUtils.mkdir_p(File.join(options[:path]))
		FileUtils.touch("#{File.join(options[:path])}/#{options[:file]}.#{options[:extension]}")
		puts "\tcreate \t#{File.join(options[:path])}"
		puts "\tcreate \t#{File.join(options[:path])}/#{options[:file]}.#{options[:extension]}"
		puts "\n"
  end
end