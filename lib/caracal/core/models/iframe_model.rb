# frozen_string_literal: true

require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the img method.
      class IFrameModel < BaseModel
        use_prefix :iframe

        has_string_attribute :url
        has_string_attribute :data

        attr_reader :iframe_ignorables, :iframe_namespaces, :iframe_relationships, :document

        def initialize(args = {}, &block)
          options = args.dup
          @document = options.delete :document
          super options, &block
        end

        #=============== PROCESSING =======================

        def preprocess!
          ::Zip::File.open(file) do |zip|
            # locate relationships xml
            entry      = zip.glob('word/_rels/document.xml.rels').first
            content    = entry.get_input_stream.read
            rel_xml    = Nokogiri::XML(content)

            # locate document xml
            entry      = zip.glob('word/document.xml').first
            content    = entry.get_input_stream.read
            doc_xml    = Nokogiri::XML(content)

            # master nodesets
            rel_nodes = rel_xml.children.first.children
            doc_root  = doc_xml.at_xpath('//w:document')
            pic_nodes = doc_xml.xpath('//pic:pic', { pic: document.namespaces.t('pic') })

            # namespaces
            @iframe_namespaces = doc_root.namespaces

            # ignorable namespaces
            if (a = doc_root.attributes['Ignorable'])
              @iframe_ignorables = a.value.split(/\s+/)
            end

            # relationships
            media_map = rel_nodes.each_with_object({}) do |node, hash|
              type = node.at_xpath('@Type').value
              next unless type.slice(-5, 5) == 'image'

              id   = node.at_xpath('@Id').value
              path = "word/#{node.at_xpath('@Target').value}"
              hash[id] = path
            end

            @iframe_relationships = pic_nodes.each_with_object([]) do |node, array|
              r_node  = node.children[1].children[0]
              r_id    = r_node.attributes['embed'].value.to_s
              r_media = media_map[r_id]

              p_node  = node.children[0].children[0]
              p_node.attributes['id'].to_s.to_i
              p_name  = p_node.attributes['name'].to_s
              p_data  = zip.glob(r_media).first.get_input_stream.read

              # register relationship
              array << { id: r_id, type: 'image', target: p_name, data: p_data }
            end
          end
        end

        #=============== GETTERS ==========================

        def file
          @file ||= begin
            if iframe_url.nil?
              file = Tempfile.new('iframe')
              file.write iframe_data
              file.rewind
            else
              file = open(iframe_url)
            end
            file
          end
        end

        def ignorables
          @iframe_ignorables || []
        end

        def namespaces
          @iframe_namespaces || {}
        end

        def relationships
          @iframe_relationships || []
        end

        #=============== VALIDATION =======================

        def valid?
          if iframe_data
            validate_presence :data
          else
            validate_presence :url
          end
        end

        private

        def option_keys
          %i[url data]
        end
      end
    end
  end
end
