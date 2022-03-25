require 'nokogiri'

require 'caracal/renderers/xml_renderer'
require 'caracal/errors'


module Caracal
  module Renderers
    class StylesRenderer < XmlRenderer

      #----------------------------------------------------
      # Public Methods
      #----------------------------------------------------

      # This method produces the xml required for the `word/styles.xml`
      # sub-document.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          wordml = xml['w']
          wordml.styles root_options do

            #========== DEFAULT STYLES ====================

            unless s = document.default_style
              raise Caracal::Errors::NoDefaultStyleError 'Document must declare a default paragraph style.'
            end
            default_id = s.style_id

            wordml.docDefaults do
              wordml.rPrDefault do
                wordml.rPr do
                  wordml.rFonts font_options(s)
                  wordml.b('w:val' => (s.style_bold ? '1' : '0'))
                  wordml.i('w:val' => (s.style_italic ? '1' : '0'))
                  wordml.caps('w:val' => (s.style_caps ? '1' : '0'))
                  wordml.smallCaps('w:val' => '0')
                  wordml.strike('w:val' => '0')
                  wordml.color('w:val' => s.style_color)
                  wordml.sz('w:val' => s.style_size)
                  wordml.u('w:val' => (s.style_underline ? 'single' : 'none'))
                  wordml.vertAlign('w:val' => 'baseline')
                end
              end
              wordml.pPrDefault do
                wordml.pPr do
                  wordml.keepNext('w:val' => '0')
                  wordml.keepLines('w:val' => '0')
                  wordml.widowControl('w:val' => '1')
                  wordml.spacing(spacing_options(s, true))
                  wordml.ind(indentation_options(s, true))
                  wordml.jc('w:val' => s.style_align.to_s)
                end
              end
            end

            wordml.style('w:styleId' => default_id, 'w:type' => 'paragraph', 'w:default' => '1') do
              wordml.name('w:val' => s.style_name)
            end

            wordml.style('w:styleId' => 'TableNormal', 'w:type' => 'table', 'w:default' => '1') do
              wordml.name('w:val' => 'Table Normal')
              wordml.pPr do
                wordml.spacing('w:lineRule' => 'auto', 'w:line' => (s.style_size * 20 * 1.15).to_i, 'w:before' => '0', 'w:after' => '0')
              end
            end

            wordml.style('w:styleId' => 'DefaultTable', 'w:type' => 'table') do
              wordml.name('w:val' => 'Default Table')
              wordml.basedOn('w:val' => 'TableNormal')

              wordml.tblPr do
                wordml.tblStyleRowBandSize('w:val' => '1')
                wordml.tblStyleColBandSize('w:val' => '1')
              end

              wordml.tcPr do
                wordml.shd 'w:fill' => 'eeeeee', 'w:val' => 'clear'
                wordml.shd 'w:vAlign' => 'top'
              end

              ## CONDITIONAL FORMATTING
              #wordml.tblStylePr('w:type' => 'wholeTable')

              #%w(band1Horz band1Vert band2Horz band2Vert).each do |type|
                #wordml.tblStylePr('w:type' => type)
              #end
              #%w(firstCol firstRow lastCol lastRow).each do |type|
                #wordml.tblStylePr('w:type' => type)
              #end
              #%w(neCell nwCell seCell swCell).each do |type|
                #wordml.tblStylePr('w:type' => type)
              #end
            end


            #========== PARA/CHAR STYLES ==================

            document.styles.each do |s|
              next if s.style_id == default_id
              next if %w(table_row table_cell).include? s.style_type

              wordml.style('w:styleId' => s.style_id, 'w:type' => s.style_type) do
                wordml.name('w:val' => s.style_name)
                wordml.basedOn('w:val' => s.style_base)
                wordml.next('w:val' => s.style_next)

                # paragraph properties
                wordml.pPr do
                  wordml.keepNext('w:val' => '0')
                  wordml.keepLines('w:val' => '0')
                  wordml.widowControl('w:val' => '1')
                  wordml.spacing(spacing_options(s)) unless spacing_options(s).nil?
                  wordml.ind(indentation_options(s)) unless indentation_options(s).nil?
                  wordml.contextualSpacing('w:val' => '1')
                  wordml.jc('w:val' => s.style_align.to_s) unless s.style_align.nil?
                  wordml.outlineLvl('w:val' => s.style_outline_lvl.to_s) unless s.style_outline_lvl.nil?
                end

                # run properties
                wordml.rPr do
                  wordml.rFonts(font_options(s)) unless s.style_font.nil?
                  wordml.b('w:val' => (s.style_bold ? '1' : '0')) unless s.style_bold.nil?
                  wordml.i('w:val' => (s.style_italic ? '1' : '0')) unless s.style_italic.nil?
                  wordml.caps('w:val' => (s.style_caps ? '1' : '0')) unless s.style_caps.nil?
                  wordml.color('w:val' => s.style_color) unless s.style_color.nil?
                  wordml.sz('w:val' => s.style_size) unless s.style_size.nil?
                  wordml.u('w:val' => (s.style_underline ? 'single' : 'none')) unless s.style_underline.nil?
                end
                ## only applies to table styles
                #if s.style_type == 'table'
                  #wordml.tblPr do
                    ##w:tblStyle [0..1]      Referenced Table Style
                    ##w:tblpPr [0..1]        Floating Table Positioning
                    ##w:tblOverlap [0..1]    Floating Table Allows Other Tables to Overlap
                    ##w:bidiVisual [0..1]    Visually Right to Left Table
                    ##w:tblStyleRowBandSize [0..1]    Number of Rows in Row Band
                    ##w:tblStyleColBandSize [0..1]    Number of Columns in Column Band
                    ##w:tblW [0..1]          Preferred Table Width
                    #wordml.jc('w:val' => s.style_align.to_s) unless s.style_align.nil?
                    #wordml.tblCellSpacing(spacing_options(s)) unless spacing_options(s).nil?
                    #wordml.tblInd(indentation_options(s)) unless indentation_options(s).nil?
                    #render_borders(wordml, 'tblBorders', s)
                    #wordml.shd 'w:fill' => s.style_background, 'w:val' => 'clear' unless s.style_background.nil?
                    ##w:tblLayout [0..1]     Table Layout
                    ##w:tblCellMar [0..1]    Table Cell Margin Defaults
                    ##w:tblLook [0..1]       Table Style Conditional Formatting Settings
                  #end
                #end

                ## only applies to table row styles
                #if s.style_type == 'table_row'
                  #wordml.trPr do
                    ##w:cnfStyle [0..1]     Table Row Conditional Formatting
                    ##w:divId [0..1]        Associated HTML div ID
                    ##w:gridBefore [0..1]   Grid Columns Before First Cell
                    ##w:gridAfter [0..1]    Grid Columns After Last Cell
                    ##w:wBefore [0..1]      Preferred Width Before Table Row
                    ##w:wAfter [0..1]       Preferred Width After Table Row
                    ##w:cantSplit [0..1]    Table Row Cannot Break Across Pages
                    ##w:trHeight [0..1]     Table Row Height
                    ##w:tblHeader [0..1]    Repeat Table Row on Every New Page
                    #wordml.tblCellSpacing(spacing_options(s)) unless spacing_options(s).nil?
                    #wordml.jc('w:val' => s.style_align.to_s) unless s.style_align.nil?
                    ##w:hidden [0..1]       Hidden Table Row Marker
                  #end
                #end

                # only applies to table cell styles
                #if s.style_type == 'table_cell'
                  #wordml.tcPr do
                    ##w:cnfStyle [0..1]      Table Cell Conditional Formatting
                    ##w:tcW [0..1]           Preferred Table Cell Width
                    ##w:gridSpan [0..1]      Grid Columns Spanned by Current Table Cell
                    ##w:hMerge [0..1]        Horizontally Merged Cell
                    ##w:vMerge [0..1]        Vertically Merged Cell
                    #render_borders(wordml, 'tcBorders', s)
                    #wordml.shd 'w:fill' => s.style_background, 'w:val' => 'clear' unless s.style_background.nil?
                    ##w:noWrap [0..1]        Don't Wrap Cell Content
                    ##w:tcMar [0..1]         Single Table Cell Margins
                    ##w:textDirection [0..1] Table Cell Text Flow Direction
                    ##w:tcFitText [0..1]     Fit Text Within Cell
                    ##w:vAlign [0..1]        Table Cell Vertical Alignment
                    ##w:hideMark [0..1]      Ignore End Of Cell Marker In Row Height Calculation
                  #end
                #end
              end
            end

          end
        end
        builder.to_xml(save_options)
      end



      #----------------------------------------------------
      # Private Methods
      #----------------------------------------------------
      private

      def render_borders(wordml, border_type, style)
        borders = %w(top left bottom right).select do |m|
          style.send("style_border_#{ m }_size") > 0
        end

        unless borders.empty?
          wordml.method_missing(border_type) do
            borders.each do |m|
              options = {
                'w:color' => style.send("style_border_#{ m }_color"),
                'w:val'   => style.send("style_border_#{ m }_style"),
                'w:sz'    => style.send("style_border_#{ m }_size")
              }
              wordml.method_missing Caracal::Core::Models::BorderModel.formatted_type(m), options
            end
          end
        end
      end


      def font_options(style)
        name = style.style_font
        { 'w:cs' => name, 'w:hAnsi' => name, 'w:eastAsia' => name, 'w:ascii' => name }
      end

      def indentation_options(style, default=false)
        left    = (default) ? style.style_indent_left.to_i  : style.style_indent_left
        right   = (default) ? style.style_indent_right.to_i : style.style_indent_right
        first   = (default) ? style.style_indent_first.to_i : style.style_indent_first
        options = nil
        if [left, right, first].compact.size > 0
          options                  = {}
          options['w:left']        = left    unless left.nil?
          options['w:right']       = right   unless right.nil?
          options['w:firstLine']   = first   unless first.nil?
        end
        options
      end

      def root_options
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

      def spacing_options(style, default=false)
        top     = (default) ? style.style_top.to_i    : style.style_top
        bottom  = (default) ? style.style_bottom.to_i : style.style_bottom
        line    = style.style_line

        options = nil
        if [top, bottom, line].compact.size > 0
          options               = {}
          options['w:lineRule'] = 'auto'
          options['w:before']   = top      unless top.nil?
          options['w:after']    = bottom   unless bottom.nil?
          options['w:line']     = line     unless line.nil?
        end
        options
      end

    end
  end
end
