$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'superb_text_constructor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'superb_text_constructor'
  s.version     = SuperbTextConstructor::VERSION
  s.authors     = ['Alexander Borovykh']
  s.email       = ['immaculate.pine@gmail.com']
  s.homepage    = ''
  s.summary     = 'Mountable WYSIWYG editor for your Rails applications'
  s.description = 'Mountable WYSIWYG editor for your Rails applications'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '> 4.1.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sass-rails', '> 4.0.0'
  s.add_dependency 'coffee-rails', '> 4.0.0'
  s.add_dependency 'carrierwave'
  s.add_dependency 'carrierwave-serializable'
  s.add_dependency 'jquery-fileupload-rails'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mini_magick'
end
