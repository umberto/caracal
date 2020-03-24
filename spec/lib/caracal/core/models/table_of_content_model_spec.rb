require 'spec_helper'

describe Caracal::Core::Models::TableOfContentModel do
  let(:options) { { legend: 'Table of contents', start_level: 2, end_level: 4 } }
  subject do
    described_class.new
  end
  
  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    
    # constants
    describe 'constants' do
      it { expect(described_class::DEFAULT_START_LEVEL).to eq 1 }
      it { expect(described_class::DEFAULT_END_LEVEL).to   eq 3 }
    end
    
    # accessors
    describe 'accessors' do
      it { expect(subject.toc_legend).to      eq nil }
      it { expect(subject.toc_start_level).to eq described_class::DEFAULT_START_LEVEL }
      it { expect(subject.toc_end_level).to   eq described_class::DEFAULT_END_LEVEL }
    end
    
  end
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------
  
  describe 'public method tests' do
  
    #=============== SETTERS ==========================
    
    describe 'setter tests' do
      describe '.toc_legend' do
        before { subject.legend(options[:legend]) }

        it { expect(subject.toc_legend).to eq options[:legend] }
      end
      describe '.toc_start_level' do
        before { subject.start_level(options[:start_level]) }

        it { expect(subject.toc_start_level).to eq options[:start_level] }
      end
      describe '.toc_end_level' do
        before { subject.end_level(options[:end_level]) }

        it { expect(subject.toc_end_level).to eq options[:end_level] }
      end
    end
    
    
    #========== HELPERS ===============================

    describe '.legend?' do
      describe 'when there is no legend' do
        it { expect(subject.legend?).to eq false }
      end
      describe 'when a legend is set' do
        before { subject.legend('Table of contents') }
        it { expect(subject.legend?).to eq false }
      end
    end


    #=============== VALIDATION =======================
    
    describe '.valid?' do
      describe 'using default values' do
        it { expect(subject.valid?).to eq true }
      end
      describe 'when passing valid data' do
        before do
          options.each do |method, value|
            subject.send(method, value)
          end
        end
        
        it { expect(subject.valid?).to eq true }
      end
      describe 'when start_level is 0' do
        before { subject.start_level(0) }
        
        it { expect(subject.valid?).to eq false }
      end
      describe 'when start_level is 100' do
        before { subject.start_level(100) }
        
        it { expect(subject.valid?).to eq false }
      end
      describe 'when end_level is 0' do
        before { subject.end_level(0) }
        
        it { expect(subject.valid?).to eq false }
      end
      describe 'when end_level is 100' do
        before { subject.end_level(100) }
        
        it { expect(subject.valid?).to eq false }
      end
      describe 'when end_level is lower than start_level' do
        before do
          subject.start_level(2)
          subject.end_level(1)
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
      let(:actual)     { subject.send(:option_keys).sort }
      let(:expected)  { [:legend, :start_level, :end_level].sort }
      
      it { expect(actual).to eq expected }
    end
    
  end
  
end