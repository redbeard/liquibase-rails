require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "liquibase-rails"
    s.rubyforge_project = "liquibase-rails"
    s.summary = "Liquibase drop-in replacement tasks for Rails migrations"
    s.email = "redbeard@gmail.com"
    s.homepage = "http://github.com/redbeard/liquibase-rails"
    s.description = "Liquibase drop-in replacement tasks for Rails migrations"
    s.authors = ["Tal Rotbart"]
    s.files = FileList["[A-Z]*.*", "lib/**/*"]
#    s.add_dependency('mime-types', '>= 1.15')
#    s.add_dependency('diff-lcs', '>= 1.1.2')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
