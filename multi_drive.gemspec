# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_drive/version'

Gem::Specification.new do |spec|
  spec.name          = "multi_drive"
  spec.version       = MultiDrive::VERSION
  spec.authors       = ["Povilas Jurčys"]
  spec.email         = ["povilas.jurcys@necolt.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"


  #gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #gem.files         = Dir["lib/**/*"] + ["README.md", "LICENSE", "paperclip-googledrive.gemspec"]
  #gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")


#  gem.required_ruby_version = ">= 1.9.2"


  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "paperclip", "~> 3.4"
  spec.add_dependency 'google-api-client', "~> 0.5"
  spec.add_dependency 'ruby-box'
  spec.add_dependency 'google_drive'
  spec.add_dependency 'rmega', '>= 0.1.4'
  #spec.add_dependency 'skydrive'


  spec.add_development_dependency "rake", ">= 0.9"
end
