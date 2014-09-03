require 'spec_helper'

describe MDS::Services::FullInventory do
  subject { described_class.new(sample_credentials) }

  describe '#query' do
    it 'returns a success response' do
      VCR.use_cassette("full_inventory_spec") do
        response = subject.query

        expect(response.success?).to eq true
        expect(response.message).to eq "Inventory for 93 products was received."
      end
    end
  end
end
