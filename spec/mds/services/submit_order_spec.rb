require 'spec_helper'

describe MDS::Services::SubmitOrder do
  subject { described_class.new(sample_credentials) }

  describe '#query' do
    it 'returns a success response' do
      VCR.use_cassette("submit_order_spec_new_order") do
        response = subject.query(sample_order)

        expect(response.success?).to eq true
        expect(response.message).to match /was received by MDS Fulfillment/
      end
    end

    context 'duplicate order' do
      it 'returns an error response' do
        VCR.use_cassette("submit_order_spec_duplicate_order") do
          response = subject.query(sample_order("R123"))

          expect(response.success?).to eq false
          expect(response.message).to match /Cannot insert duplicate key/
        end
      end
    end
  end
end
