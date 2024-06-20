# frozen_string_literal: true

require 'tilt/template'
require 'caracal'

module Tilt
  class CaracalTemplate < Template
    self.default_mime_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'

    def prepare
      @code = <<-RUBY
        Caracal::Document.render do |docx|
          #{data}
        end
      RUBY
    end

    def precompiled_template(_locals)
      @code
    end
  end
end
