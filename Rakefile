require 'spec/rake/spectask'

task :default => [:spec]

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', 'spec/spec.opts']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "httping"
    gem.date = %q{2009-09-15}
    gem.default_executable = %q{httping}
    gem.summary = "Measures web site response time"
    gem.description = "Measures web site response time"
    gem.email = "john.pignata@gmail.com"
    gem.authors = ["John Pignata"]
    gem.add_development_dependency "rspec", "1.2.9"
    gem.add_development_dependency "fakeweb", "1.2.6"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end