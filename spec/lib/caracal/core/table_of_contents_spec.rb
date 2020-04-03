require 'spec_helper'

describe Caracal::Core::TableOfContents do
  subject { Caracal::Document.new }
  
  
  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    
    # .toc
    describe '.toc' do
      let!(:size) { subject.contents.size }
      
      before { subject.toc }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::TableOfContentModel) }
    end
    
    # .table_of_contents
    describe '.toc' do
      let!(:size) { subject.contents.size }
      
      before { subject.table_of_contents }
      
      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::TableOfContentModel) }
    end
  end
  
end