Gem::Specification.new do |gem|
  gem.name = 'karma_count'
  gem.version = '0.0.1'
  gem.date = Date.today.to_s
  
  gem.author = ["PJ Wickwire"]
  gem.email = 'pjpeterww@gmail.com'
  gem.files = ["lib/karma_count.rb", "lib/cli.rb", "lib/scraper.rb", "lib/student.rb", "bin/karma"]
  
  gem.summary = "A gem to list out all the learn-verified students karma points"
  gem.homepage = 'http://github.com/pajamaw'
  gem.licenses = 'MIT'
  
  gem.executables << 'karma'

  gem
end
 
