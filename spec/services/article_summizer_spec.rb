require 'rails_helper'

describe ArticleSummizer, type: :service do
  subject { described_class.new(url: url, content: content) }

  context 'with content present' do
    let(:url) { 'https://example.com' }
    let(:content) { "There's a strange feeling that the birds that were hanging on to me are no longer. There are lots of birds with broken wings and they can't fly any longer. They are drinking from puddles and can't see straight let alone fly." }

    describe '.perform' do
      it 'returns the content summized article' do
        expect(described_class.perform(url, content)).to eq "There's a strange feeling that the birds that were hanging on to me are no longer."
      end
    end
  end
end