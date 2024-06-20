# frozen_string_literal: true

require 'spec_helper'

describe Caracal::Core::Models::BookmarkModel do
  subject do
    described_class.new do
      name    'myAnchor'
      start   false
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do
    # accessors
    describe 'accessors' do
      it { expect(subject.bookmark_name).to eq  'myAnchor' }
      it { expect(subject.bookmark_start).to eq false }
    end
  end

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    #=============== GETTERS ==========================

    # .run_attributes
    describe '.run_attributes' do
      let(:expected) { { id: nil, name: 'myAnchor', start: false } }

      it { expect(subject.run_attributes).to eq expected }
    end

    #=============== SETTERS ==========================

    # booleans
    describe '.start' do
      before { subject.start(true) }

      it { expect(subject.bookmark_start).to eq true }
    end

    # strings
    describe '.name' do
      before { subject.name('999999') }

      it { expect(subject.bookmark_name).to eq '999999' }
    end

    #=============== STATE HELPERS ========================

    describe '.start?' do
      describe 'when start is true' do
        before { subject.start(true) }

        it { expect(subject.start?).to eq true }
      end
      describe 'when start is false' do
        before { subject.start(false) }

        it { expect(subject.start?).to eq false }
      end
    end

    #=============== VALIDATION ===========================

    describe '.valid?' do
      describe 'when required attributes provided' do
        it { expect(subject.valid?).to eq true }
      end
      describe 'when start is true' do
        before { subject.start(true) }

        [:name].each do |prop|
          describe "when #{prop} is empty" do
            before do
              allow(subject).to receive("bookmark_#{prop}").and_return(nil)
            end

            it { expect(subject.valid?).to eq false }
          end
        end
      end
    end
  end

  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do
    # .option_keys
    describe '.option_keys' do
      let(:actual)   { subject.send(:option_keys).sort }
      let(:expected) { %i[name start].sort }

      it { expect(actual).to eq expected }
    end
  end
end
