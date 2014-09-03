require 'spec_helper'

describe MDS::Services::ShippingStatus::Tracking do
  subject { described_class.new(sample_credentials) }

  describe '#query' do
    it 'returns a success response' do
      VCR.use_cassette("tracking_spec", record: :all) do
        response = subject.query

        expect(response.success?).to eq true
        expect(response.message).to eq "0 shipments were received."
      end
    end
  end
end
