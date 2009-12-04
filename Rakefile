Dir['tasks/**/*.rake'].each { |t| load t }

require File.dirname(__FILE__) + '/lib/ruote-kit/client'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'ruote-kit-client'
    gemspec.version = RuoteKit::Client::VERSION
    gemspec.summary = 'RESTful client for ruote-kit'
    gemspec.email = 'kenneth.kalmer@gmail.com'
    gemspec.homepage = 'http://github.com/kennethkalmer/ruote-kit-client'
    gemspec.authors = ['kenneth.kalmer@gmail.com']
    gemspec.post_install_message = IO.read('PostInstall.txt')
    gemspec.extra_rdoc_files.include '*.txt'

    gemspec.add_dependency 'rufus-jig', '>=0.1.1'
    gemspec.add_development_dependency 'rspec'
    gemspec.add_development_dependency 'cucumber'
    gemspec.add_development_dependency 'mocha'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with 'gem install jeweler'"
end

# TODO - want other tests/tasks run by default? Add them to the list
task :default => [:spec] #, :features]
