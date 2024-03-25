require 'nokogiri'
require 'caracal/renderers/xml_renderer'
require 'caracal/errors'

module Caracal
  module Renderers
    class ThemeRenderer < XmlRenderer

      def self.render(doc, theme)
        self.new(doc, theme).to_xml
      end

      def initialize(doc, theme)
        @theme = theme
        super doc
      end

      # This method produces the xml required for the `word/theme/theme1.xml`
      # sub-document.
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          a = xml['a']
          a.theme root_options do
            a.themeElements do
              a.clrScheme 'name' => @theme.theme_name do
                a.dk1 do
                  a.srgbClr val: @theme.theme_color_dark1
                end
                a.lt1 do
                  a.srgbClr val: @theme.theme_color_light1
                end
                a.dk2 do
                  a.srgbClr val: @theme.theme_color_dark2
                end
                a.lt2 do
                  a.srgbClr val: @theme.theme_color_light2
                end
                a.accent1 do
                  a.srgbClr val: @theme.theme_color_accent1
                end
                a.accent2 do
                  a.srgbClr val: @theme.theme_color_accent2
                end
                a.accent3 do
                  a.srgbClr val: @theme.theme_color_accent3
                end
                a.accent4 do
                  a.srgbClr val: @theme.theme_color_accent4
                end
                a.accent5 do
                  a.srgbClr val: @theme.theme_color_accent5
                end
                a.accent6 do
                  a.srgbClr val: @theme.theme_color_accent6
                end
                a.hlink do
                  a.srgbClr val: @theme.theme_color_hyperlink
                end
                a.folHlink do
                  a.srgbClr val: @theme.theme_color_visited_hyperlink
                end
              end

              a.fontScheme name: 'Caracal' do
                a.majorFont do
                  a.latin typeface: 'Times New Roman'
                  a.ea typeface: ''
                  a.cs typeface: ''
                  a.font script: 'Jpan', typeface: 'ＭＳ ゴシック'
                  a.font script: 'Hang', typeface: '맑은 고딕'
                  a.font script: 'Hans', typeface: '宋体'
                  a.font script: 'Hant', typeface: '新細明體'
                  a.font script: 'Arab', typeface: 'Times New Roman'
                  a.font script: 'Hebr', typeface: 'Times New Roman'
                  a.font script: 'Thai', typeface: 'Angsana New'
                  a.font script: 'Ethi', typeface: 'Nyala'
                  a.font script: 'Beng', typeface: 'Vrinda'
                  a.font script: 'Gujr', typeface: 'Shruti'
                  a.font script: 'Khmr', typeface: 'MoolBoran'
                  a.font script: 'Knda', typeface: 'Tunga'
                  a.font script: 'Guru', typeface: 'Raavi'
                  a.font script: 'Cans', typeface: 'Euphemia'
                  a.font script: 'Cher', typeface: 'Plantagenet Cherokee'
                  a.font script: 'Yiii', typeface: 'Microsoft Yi Baiti'
                  a.font script: 'Tibt', typeface: 'Microsoft Himalaya'
                  a.font script: 'Thaa', typeface: 'MV Boli'
                  a.font script: 'Deva', typeface: 'Mangal'
                  a.font script: 'Telu', typeface: 'Gautami'
                  a.font script: 'Taml', typeface: 'Latha'
                  a.font script: 'Syrc', typeface: 'Estrangelo Edessa'
                  a.font script: 'Orya', typeface: 'Kalinga'
                  a.font script: 'Mlym', typeface: 'Kartika'
                  a.font script: 'Laoo', typeface: 'DokChampa'
                  a.font script: 'Sinh', typeface: 'Iskoola Pota'
                  a.font script: 'Mong', typeface: 'Mongolian Baiti'
                  a.font script: 'Viet', typeface: 'Times New Roman'
                  a.font script: 'Uigh', typeface: 'Microsoft Uighur'
                end

                a.minorFont do
                  a.latin typeface: 'Times New Roman'
                  a.ea typeface: ''
                  a.cs typeface: ''
                  a.font script: 'Jpan', typeface: 'ＭＳ ゴシック'
                  a.font script: 'Hang', typeface: '맑은 고딕'
                  a.font script: 'Hans', typeface: '宋体'
                  a.font script: 'Hant', typeface: '新細明體'
                  a.font script: 'Arab', typeface: 'Times New Roman'
                  a.font script: 'Hebr', typeface: 'Times New Roman'
                  a.font script: 'Thai', typeface: 'Angsana New'
                  a.font script: 'Ethi', typeface: 'Nyala'
                  a.font script: 'Beng', typeface: 'Vrinda'
                  a.font script: 'Gujr', typeface: 'Shruti'
                  a.font script: 'Khmr', typeface: 'MoolBoran'
                  a.font script: 'Knda', typeface: 'Tunga'
                  a.font script: 'Guru', typeface: 'Raavi'
                  a.font script: 'Cans', typeface: 'Euphemia'
                  a.font script: 'Cher', typeface: 'Plantagenet Cherokee'
                  a.font script: 'Yiii', typeface: 'Microsoft Yi Baiti'
                  a.font script: 'Tibt', typeface: 'Microsoft Himalaya'
                  a.font script: 'Thaa', typeface: 'MV Boli'
                  a.font script: 'Deva', typeface: 'Mangal'
                  a.font script: 'Telu', typeface: 'Gautami'
                  a.font script: 'Taml', typeface: 'Latha'
                  a.font script: 'Syrc', typeface: 'Estrangelo Edessa'
                  a.font script: 'Orya', typeface: 'Kalinga'
                  a.font script: 'Mlym', typeface: 'Kartika'
                  a.font script: 'Laoo', typeface: 'DokChampa'
                  a.font script: 'Sinh', typeface: 'Iskoola Pota'
                  a.font script: 'Mong', typeface: 'Mongolian Baiti'
                  a.font script: 'Viet', typeface: 'Times New Roman'
                  a.font script: 'Uigh', typeface: 'Microsoft Uighur'
                end
              end

              a.fmtScheme name: 'Caracal' do
                a.fillStyleLst do
                  a.solidFill do
                    a.schemeClr val: 'phClr'
                  end

                  a.gradFill rotWithShape: 1 do
                    a.gsLst do
                      a.gs pos: 0 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 50000
                          a.satMod val: 300000
                        end
                      end
                      a.gs pos: 35000 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 37000
                          a.satMod val: 300000
                        end
                      end
                      a.gs pos: 100000 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 15000
                          a.satMod val: 350000
                        end
                      end
                    end
                    a.lin ang: 16200000, scaled: 1
                  end

                  a.gradFill rotWithShape: 1 do
                    a.gsLst do
                      a.gs pos: 0 do
                        a.schemeClr val: 'phClr' do
                          a.shade val: 51000
                          a.satMod val: 130000
                        end
                      end
                      a.gs pos: 80000 do
                        a.schemeClr val: 'phClr' do
                          a.shade val: 93000
                          a.satMod val: 130000
                        end
                      end
                      a.gs pos: 100000 do
                        a.schemeClr val: 'phClr' do
                          a.shade val: 94000
                          a.satMod val: 135000
                        end
                      end
                    end
                    a.lin ang: 16200000, scaled: 0
                  end
                end
                a.lnStyleLst do
                  a.ln w: 9525, cap: 'flat', cmpd: 'sng', algn: 'ctr' do
                    a.solidFill do
                      a.schemeClr val: 'phClr' do
                        a.shade val: 95000
                        a.satMod val: 105000
                      end
                    end
                    a.prstDash val: 'solid'
                  end
                  a.ln w: 25400, cap: 'flat', cmpd: 'sng', algn: 'ctr' do
                    a.solidFill do
                      a.schemeClr val: 'phClr'
                    end
                    a.prstDash val: 'solid'
                  end
                  a.ln w: 38100, cap: 'flat', cmpd: 'sng', algn: 'ctr' do
                    a.solidFill do
                      a.schemeClr val: 'phClr'
                    end
                    a.prstDash val: 'solid'
                  end
                end
                a.effectStyleLst do
                  a.effectStyle do
                    a.effectLst do
                      a.outerShdw blurRad: 40000, dist: 20000, dir: 5400000, rotWithShape: 0 do
                        a.srgbClr val: '000000' do
                          a.alpha val: 38000
                        end
                      end
                    end
                  end
                  a.effectStyle do
                    a.effectLst do
                      a.outerShdw blurRad: 40000, dist: 23000, dir: 5400000, rotWithShape: 0 do
                        a.srgbClr val: '000000' do
                          a.alpha val: 35000
                        end
                      end
                    end
                  end
                  a.effectStyle do
                    a.effectLst do
                      a.outerShdw blurRad: 40000, dist: 23000, dir: 5400000, rotWithShape: 0 do
                        a.srgbClr val: '000000' do
                          a.alpha val: 35000
                        end
                      end
                    end
                    a.scene3d do
                      a.camera prst: 'orthographicFront' do
                        a.rot lat: 0, lon: 0, rev: 0
                      end
                      a.lightRig rig: 'threePt', dir: 't' do
                        a.rot lat: 0, lon: 0, rev: 1200000
                      end
                    end
                    a.sp3d do
                      a.bevelT w: 63500, h: 25400
                    end
                  end
                end

                a.bgFillStyleLst do
                  a.solidFill do
                    a.schemeClr val: 'phClr'
                  end

                  a.gradFill rotWithShape: 1 do
                    a.gsLst do
                      a.gs pos: 0 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 40000
                          a.satMod val: 350000
                        end
                      end
                      a.gs pos: 40000 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 45000
                          a.shade val: 99000
                          a.satMod val: 350000
                        end
                      end
                      a.gs pos: 100000 do
                        a.schemeClr val: 'phClr' do
                          a.shade val: 20000
                          a.satMod val: 255000
                        end
                      end
                    end
                    a.path path: 'circle' do
                      a.fillToRect l: 50000, t: -80000, r: 50000, b: 180000
                    end
                  end

                  a.gradFill rotWithShape: 1 do
                    a.gsLst do
                      a.gs pos: 0 do
                        a.schemeClr val: 'phClr' do
                          a.tint val: 80000
                          a.satMod val: 300000
                        end
                      end
                      a.gs pos: 100000 do
                        a.schemeClr val: 'phClr' do
                          a.shade val: 30000
                          a.satMod val: 200000
                        end
                      end
                    end
                    a.path path: 'circle' do
                      a.fillToRect l: 50000, t: 50000, r: 50000, b: 50000
                    end
                  end
                end
              end
            end
            a.objectDefaults
            a.extraClrSchemeLst
          end
        end


        builder.to_xml save_options
      end

      def root_options
        {
          'xmlns:a' => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'name'    => @theme.theme_name
        }
      end

    end
  end
end
