# -*- encoding: utf-8 -*-
# stub: jekyll-theme-future-imperfect 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-theme-future-imperfect".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Eric Johnson".freeze, "HTML5 UP".freeze]
  s.date = "2020-03-12"
  s.email = ["eric.j.johnson22@gmail.com".freeze]
  s.homepage = "http://github.com/ejohnso49/jekyll-theme-future-imperfect".freeze
  s.licenses = ["CC-BY-3.0".freeze]
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "Jekyll adaption of the Future Imperfect theme by HTML5 UP".freeze

  s.installed_by_version = "3.0.3.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 2.1"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
    else
      s.add_dependency(%q<jekyll>.freeze, ["~> 4.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 2.1"])
      s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    end
  else
    s.add_dependency(%q<jekyll>.freeze, ["~> 4.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 2.1"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
  end
end
