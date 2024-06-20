# frozen_string_literal: true

require 'spec_helper'

describe Caracal::View do
  let(:view_object) { Object.new.tap { |o| o.extend(described_class) } }

  it 'provides a Caracal::Document object by default' do
    expect(view_object.docx).to be_kind_of(Caracal::Document)
  end

  it 'delegates unhandled methods to object returned by document method' do
    docx = instance_double('Document')
    allow(view_object).to receive(:docx).and_return(docx)

    allow(docx).to receive(:some_delegated_method)

    view_object.some_delegated_method

    expect(docx).to have_received(:some_delegated_method)
  end

  it 'allows a block-like DSL via the update method' do
    docx = instance_double('Document')
    allow(view_object).to receive(:docx).and_return(docx)

    allow(docx).to receive(:foo)
    allow(docx).to receive(:bar)

    view_object.update do
      foo
      bar
    end
    expect(docx).to have_received(:foo)
    expect(docx).to have_received(:bar)
  end

  it 'aliases save_as() to document.save()' do
    docx = instance_double('Document')
    allow(docx).to receive(:save)

    allow(view_object).to receive(:docx).and_return(docx)

    view_object.save('foo.docx')
    expect(docx).to have_received(:save)
  end

  describe '#respond_to?' do
    subject { view_object.respond_to?(method) }

    context 'when called with an existing method from Caracal::Document' do
      let(:method) { :page }

      it { is_expected.to be_truthy }
    end

    context 'when called with a non-existing method' do
      let(:method) { :non_existing_method }

      it { is_expected.to be_falsey }
    end
  end
end
