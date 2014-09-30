require 'spec_helper'

describe MDS::Services::SubmitOrder do
  subject { described_class.new(sample_credentials) }

  describe '#query' do
    it "allows for internation characters" do
      VCR.use_cassette("submit_internation_order") do

      end
    end

    it 'returns a success response' do
      VCR.use_cassette("submit_order_spec_new_order") do
        response = subject.query(sample_shipment("R123456NEW"))

        expect(response.success?).to eq true
        expect(response.message).to match /was received by MDS Fulfillment/
      end
    end

    context 'duplicate order' do
      it 'returns an error response' do
        VCR.use_cassette("submit_order_spec_duplicate_order") do
          response = subject.query(sample_shipment("R123"))

          expect(response.success?).to eq false
          expect(response.message).to match /Cannot insert duplicate key/
        end
      end
    end

    context 'missing totals' do
      it 'uses 0 as value' do
        VCR.use_cassette("submit_order_spec_no_totals") do
          shipment = sample_shipment("R493330123")
          shipment.delete("totals")

          response = subject.query(shipment)

          expect(response.success?).to eq true
          expect(response.message).to match /was received by MDS Fulfillment/
        end
      end
    end

    context 'missing billing_address' do
      it 'uses shipping_address as billing_address' do
        VCR.use_cassette("submit_order_spec_no_billing_address") do
          shipment = sample_shipment("R357790123")
          shipment.delete("billing_address")

          response = subject.query(shipment)
          expect(response.success?).to eq true
          expect(response.message).to match /was received by MDS Fulfillment/
        end
      end
    end
  end
end
