# frozen_string_literal: true

# stub: caracal 1.7.2 ruby lib

Gem::Specification.new do |s|
  s.name = 'caracal'
  s.version = '1.7.3'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.require_paths = ['lib']
  s.authors = ['Trade Infomatics', 'John Dugan', 'Sprengnetter Real Estate', 'Willem van Kerkhof']
  s.date = '2022-01-26'
  s.description = ' Caracal is a pure Ruby Microsoft Word generation library that produces professional quality MSWord documents (docx) using a simple, HTML-style DSL. '
  s.email = ['jpdugan@gmail.com', 'willem.van-kerkhof@innoq.com']

  s.files = Dir['{lib,spec}/**/*', 'Rakefile', 'README.md', 'CHANGELOG.md', 'Gemfile', 'LICENSE.txt', 'caracal.gemspec']
  s.homepage = 'https://github.com/sprengnetter/caracal'
  s.licenses = ['MIT']
  s.rubygems_version = '3.3.3'
  s.summary = 'Fast, professional Microsoft Word (docx) writer for Ruby.'
  s.test_files = ['spec/lib/caracal/core/bookmarks_spec.rb', 'spec/lib/caracal/core/file_name_spec.rb',
                  'spec/lib/caracal/core/fonts_spec.rb', 'spec/lib/caracal/core/iframes_spec.rb', 'spec/lib/caracal/core/ignorables_spec.rb', 'spec/lib/caracal/core/images_spec.rb', 'spec/lib/caracal/core/list_styles_spec.rb', 'spec/lib/caracal/core/lists_spec.rb', 'spec/lib/caracal/core/models/base_model_spec.rb', 'spec/lib/caracal/core/models/bookmark_model_spec.rb', 'spec/lib/caracal/core/models/border_model_spec.rb', 'spec/lib/caracal/core/models/font_model_spec.rb', 'spec/lib/caracal/core/models/iframe_model_spec.rb', 'spec/lib/caracal/core/models/image_model_spec.rb', 'spec/lib/caracal/core/models/line_break_model_spec.rb', 'spec/lib/caracal/core/models/link_model_spec.rb', 'spec/lib/caracal/core/models/list_item_model_spec.rb', 'spec/lib/caracal/core/models/list_model_spec.rb', 'spec/lib/caracal/core/models/list_style_model_spec.rb', 'spec/lib/caracal/core/models/margin_model_spec.rb', 'spec/lib/caracal/core/models/namespace_model_spec.rb', 'spec/lib/caracal/core/models/page_break_model_spec.rb', 'spec/lib/caracal/core/models/page_number_model_spec.rb', 'spec/lib/caracal/core/models/page_size_model_spec.rb', 'spec/lib/caracal/core/models/paragraph_model_spec.rb', 'spec/lib/caracal/core/models/relationship_model_spec.rb', 'spec/lib/caracal/core/models/rule_model_spec.rb', 'spec/lib/caracal/core/models/style_model_spec.rb', 'spec/lib/caracal/core/models/table_cell_model_spec.rb', 'spec/lib/caracal/core/models/table_model_spec.rb', 'spec/lib/caracal/core/models/table_of_content_model_spec.rb', 'spec/lib/caracal/core/models/text_model_spec.rb', 'spec/lib/caracal/core/namespaces_spec.rb', 'spec/lib/caracal/core/page_breaks_spec.rb', 'spec/lib/caracal/core/page_numbers_spec.rb', 'spec/lib/caracal/core/page_settings_spec.rb', 'spec/lib/caracal/core/relationships_spec.rb', 'spec/lib/caracal/core/rules_spec.rb', 'spec/lib/caracal/core/styles_spec.rb', 'spec/lib/caracal/core/table_of_contents_spec.rb', 'spec/lib/caracal/core/tables_spec.rb', 'spec/lib/caracal/core/text_spec.rb', 'spec/lib/caracal/errors_spec.rb', 'spec/lib/caracal/view_spec.rb', 'spec/spec_helper.rb', 'spec/support/_fixtures/snippet.docx']

  s.installed_by_version = '3.3.3' if s.respond_to? :installed_by_version

  s.specification_version = 4 if s.respond_to? :specification_version

  if s.respond_to? :add_runtime_dependency
    s.add_runtime_dependency('nokogiri', ['~> 1.6'])
    s.add_runtime_dependency('rubyzip', ['>= 1.1.0', '< 3.0'])
    s.add_runtime_dependency('tilt', ['>= 1.4'])
    s.add_development_dependency('bundler', ['~> 2.0'])
    s.add_development_dependency('rake', ['~> 13.0'])
    s.add_development_dependency('rspec', ['~> 3.0'])
  else
    s.add_dependency('bundler', ['~> 2.0'])
    s.add_dependency('nokogiri', ['~> 1.6'])
    s.add_dependency('rake', ['~> 13.0'])
    s.add_dependency('rspec', ['~> 3.0'])
    s.add_dependency('rubyzip', ['>= 1.1.0', '< 3.0'])
    s.add_dependency('tilt', ['>= 1.4'])
    s.add_dependency('zip-zip', ['>= 1.0.0'])
  end
end
