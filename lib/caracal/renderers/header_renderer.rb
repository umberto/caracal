require 'nokogiri'

require 'caracal/renderers/document_renderer'


module Caracal
  module Renderers
    class HeaderRenderer < DocumentRenderer

      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/header1.xml`
      # sub-document.
      #
      def to_xml
        positions = [:left, :center, :right]
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml['w'].hdr header_root_options do
            xml['w'].tbl do
              xml['w'].tblPr do
                xml['w'].tblStyle({ 'w:val' => "TableNormal" })
                xml['w'].bidiVisual({ 'w:val' => "0" })
                xml['w'].tblW({ 'w:w' => "0", 'w:type' => "auto" })
                xml['w'].tblLayout({ 'w:type' => "fixed" })
                xml['w'].tblLook({ 'w:val' => "06A0", 'w:firstRow' => "1", 'w:lastRow' => "0", 'w:firstColumn' => "1", 'w:lastColumn' => "0", 'w:noHBand' => "1", 'w:noVBand' => "1" })
              end
              xml['w'].tblGrid do
                positions.size.times do
                  xml['w'].gridCol({ 'w:w' => "3120" })
                end
              end
              xml['w'].tr paragraph_options do
                positions.each do |position|
                  xml['w'].tc do
                    xml['w'].tcPr do
                      xml['w'].tcW({ 'w:w' => '3120', 'w:type' => 'dxa' })
                      xml['w'].vAlign({ 'w:val' => 'top' })
                      xml['w'].tcMar
                      xml['w'].mar
                      xml['w'].jc({ 'w:val' => position })
                    end
                    document.contents_for(position).each do |model|
                      method = render_method_for_model(model)
                      model.style('Header') if model.respond_to? :style
                      send(method, xml, model)
                    end
                    xml['w'].p paragraph_options do
                      xml['w'].pPr do
                        xml['w'].pStyle({ 'w:val' => 'Header' })
                        xml['w'].bidi({ 'w:val' => '0' })
                        xml['w'].jc({ 'w:val' => position })
                        xml['w'].ind({ "w:#{position}" => '-115' }) unless position == :center
                      end
                    end
                  end
                end
              end
            end
            if document.contents_for(nil).each do |model|
              method = render_method_for_model(model)
              model.style('Header') if model.respond_to? :style
              send(method, xml, model)
            end.empty?
              xml['w'].p paragraph_options do
                xml['w'].pPr do
                  xml['w'].pStyle({ 'w:val' => 'Header' })
                  xml['w'].bidi({ 'w:val' => '0' })
                end
              end
            end
          end
        end
        builder.to_xml(save_options)
      end

      def render_pagebreak(xml, model); end

      #-------------------------------------------------------------
      # Private Methods
      #-------------------------------------------------------------
      private

      def header_root_options
        {
          'xmlns:mc'  => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'   => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'   => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'   => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'   => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'  => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10' => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'   => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne' => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'  => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'   => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic' => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'   => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'  => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm' => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end

    end
  end
end


