require_relative "lib/keystone_colors/version"

Gem::Specification.new do |spec|
  spec.name        = "keystone_colors"
  spec.version     = KeystoneColors::VERSION
  spec.authors     = [ "Tyler Schneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/tylercschneider/keystone_colors"
  spec.summary     = "Per-user color palette settings for Keystone UI."
  spec.description = "A companion engine for keystone_ui that provides preset themes and per-user color palette persistence."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/tylercschneider/keystone_colors"
  spec.metadata["changelog_uri"]     = "https://github.com/tylercschneider/keystone_colors/blob/main/CHANGELOG.md"

  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "keystone_ui", ">= 0.4.1"
  spec.add_dependency "railties", ">= 7.0"
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_dependency "activesupport", ">= 7.0"
end
