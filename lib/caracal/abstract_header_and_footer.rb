# frozen_string_literal: true

require 'caracal/core/bookmarks'
require 'caracal/core/custom_properties'
require 'caracal/core/file_name'
require 'caracal/core/fonts'
require 'caracal/core/iframes'
require 'caracal/core/ignorables'
require 'caracal/core/images'
require 'caracal/core/list_styles'
require 'caracal/core/lists'
require 'caracal/core/namespaces'
require 'caracal/core/page_breaks'
require 'caracal/core/page_numbers'
require 'caracal/core/page_settings'
require 'caracal/core/relationships'
require 'caracal/core/rules'
require 'caracal/core/styles'
require 'caracal/core/tables'
require 'caracal/core/text'
require 'caracal/core/raw_xml'

module Caracal
  class AbstractHeaderAndFooter
    include Caracal::Core::CustomProperties
    include Caracal::Core::FileName
    include Caracal::Core::Ignorables
    include Caracal::Core::Namespaces
    include Caracal::Core::Relationships

    include Caracal::Core::Fonts
    include Caracal::Core::PageSettings
    include Caracal::Core::PageNumbers
    include Caracal::Core::Styles
    include Caracal::Core::ListStyles

    include Caracal::Core::Bookmarks
    include Caracal::Core::IFrames
    include Caracal::Core::Images
    include Caracal::Core::Lists
    include Caracal::Core::PageBreaks
    include Caracal::Core::Rules
    include Caracal::Core::Tables
    include Caracal::Core::Text
    include Caracal::Core::RawXml

    attr_reader :index, :type

    def initialize(index: 1, type: 'default')
      @index = index
      @type = type
      page_size
      page_margins top: 1440, bottom: 1440, left: 1440, right: 1440

      %i[font list_style namespace style].each do |method|
        collection = self.class.send("default_#{method}s")
        collection.each do |item|
          send(method, item)
        end
      end
    end

    def contents
      @contents ||= []
    end

    def contents_for(position)
      contents.select { |model| model.alignment == position }
    end
  end
end
