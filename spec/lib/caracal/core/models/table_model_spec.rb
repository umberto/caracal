# frozen_string_literal: true

require 'spec_helper'

describe Caracal::Core::Models::TableModel do
  subject do
    described_class.new do
      data            [['top left', 'top right'], ['bottom left', 'bottom right']]
      align           :end
      border_color    '666666'
      border_line     :double
      border_size     8
      border_spacing  4
      width           8000
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_TABLE_ALIGN).to          eq :center }
      # it { expect(described_class::DEFAULT_TABLE_BORDER_COLOR).to   eq 'auto' }
      # it { expect(described_class::DEFAULT_TABLE_BORDER_LINE).to    eq :single }
      # it { expect(described_class::DEFAULT_TABLE_BORDER_SIZE).to    eq 0 }
      # it { expect(described_class::DEFAULT_TABLE_BORDER_SPACING).to eq 0 }
      it { expect(described_class::DEFAULT_TABLE_REPEAT_HEADER).to  eq 0 }
    end

    # accessors
    describe 'accessors' do
      it { expect(subject.table_align).to          eq :end }
      it { expect(subject.table_width).to          eq 8000 }
      it { expect(subject.table_border_color).to   eq '666666' }
      it { expect(subject.table_border_line).to    eq :double }
      it { expect(subject.table_border_size).to    eq 8 }
      it { expect(subject.table_border_spacing).to eq 4 }
      it { expect(subject.table_repeat_header).to  eq 0 }
    end
  end

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    #=============== DATA ACCESSORS ====================

    describe 'data tests' do
      let(:data) { [['top left', 'top right'], ['bottom left', 'bottom right']] }

      before do
        allow(subject).to receive(:rows).and_return(data)
      end

      # .rows
      describe '.rows' do
        it { expect(subject.rows[0]).to be_a(Array) }
        it { expect(subject.rows[0][1]).to eq 'top right' }
      end

      # .cols
      describe '.cols' do
        it { expect(subject.cols[0]).to be_a(Array) }
        it { expect(subject.cols[0][1]).to eq 'bottom left' }
      end

      # .cells
      describe '.cells' do
        it { expect(subject.cells[0]).to eq 'top left' }
      end
    end

    #=============== GETTERS ==========================

    describe 'getter tests' do
      # border attrs
      describe 'border attr tests' do
        let(:model) { Caracal::Core::Models::BorderModel.new color: '000000', line: :double, size: 10, spacing: 2 }

        before do
          allow(subject.border).to receive(:table_border_color).and_return('auto')
          allow(subject.border).to receive(:table_border_line).and_return(:single)
          allow(subject.border).to receive(:table_border_size).and_return(8)
          allow(subject.border).to receive(:table_border_spacing).and_return(1)
        end

        %i[top bottom left right horizontal vertical].each do |m|
          %i[color line size spacing].each do |attr|
            describe "table_border_#{m}_#{attr}" do
              let(:actual) { subject.send("table_border_#{m}_#{attr}") }

              describe 'when detailed setting present' do
                before do
                  allow(subject).to receive("table_border_#{m}").and_return(model)
                end

                it { expect(actual).to eq model.send("border_#{attr}") }
              end
              describe 'when detailed setting not present' do
                before do
                  allow(subject).to receive("table_border_#{m}").and_return(nil)
                end

                it { expect(actual).to eq subject.send("table_border_#{attr}") }
              end
            end
          end
          describe "table_border_#{m}_total_size" do
            let(:actual) { subject.send("table_border_#{m}_total_size") }

            describe 'when detailed setting present' do
              before do
                allow(subject).to receive("table_border_#{m}").and_return(model)
              end

              it { expect(actual).to eq model.total_size }
            end
            describe 'when detailed setting not present' do
              before do
                allow(subject).to receive("table_border_#{m}").and_return(nil)
              end

              it { expect(actual).to eq subject.send("table_border_#{m}_total_size") }
            end
          end
        end
      end
    end

    #=============== SETTERS ==========================

    # .align
    describe '.align' do
      before { subject.align(:center) }

      it { expect(subject.table_align).to eq :center }
    end

    # .border_color
    describe '.border_color' do
      before { subject.border_color('999999') }

      it { expect(subject.table_border_color).to eq '999999' }
    end

    # .border_line
    describe '.border_line' do
      before { subject.border_line(:none) }

      it { expect(subject.table_border_line).to eq :none }
    end

    # .border_size
    describe '.border_size' do
      before { subject.border_size(24) }

      it { expect(subject.table_border_size).to eq 24 }
    end

    # .border_spacing
    describe '.border_spacing' do
      before { subject.border_spacing(16) }

      it { expect(subject.table_border_spacing).to eq 16 }
    end

    # .width
    describe '.width' do
      before { subject.width(7500) }

      it { expect(subject.table_width).to eq 7500 }
    end

    # .repeat_header
    describe '.repeat_header' do
      before { subject.repeat_header(2) }

      it { expect(subject.table_repeat_header).to eq 2 }
    end

    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when data provided' do
        it { expect(subject.valid?).to eq true }
      end
      describe 'when no data provided' do
        before do
          allow(subject).to receive(:cells).and_return([[]])
        end

        it { expect(subject.valid?).to eq false }
      end
    end
  end

  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do
    # .option_keys
    describe '.option_keys' do
      let(:actual) { subject.send(:option_keys).sort }
      let(:expected) do
        %i[data align width column_widths border_color border_line border_size border_spacing border_top border_bottom
           border_left border_right border_horizontal border_vertical repeat_header bgcolor bgstyle border border_theme_color caption col_band_size indent layout row_band_size style theme_bgcolor].sort
      end

      it { expect(actual).to eq expected }
    end
  end
end
