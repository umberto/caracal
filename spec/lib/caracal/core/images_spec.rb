# frozen_string_literal: true

require 'spec_helper'

describe Caracal::Core::Images do
  subject { Caracal::Document.new }

  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do
    # .img
    describe '.img' do
      let!(:size) { subject.contents.size }

      before { subject.img 'https://www.google.com/images/srpr/logo11w.png', width: 538, height: 190, data: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/D/PwAHAwL/qGeMxAAAAABJRU5ErkJggg==' }

      it { expect(subject.contents.size).to eq size + 1 }
      it { expect(subject.contents.last).to be_a(Caracal::Core::Models::ImageModel) }
      it { expect(subject.contents.last.image_data).to be_truthy }
    end
  end
end
