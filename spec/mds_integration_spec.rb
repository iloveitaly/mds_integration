require 'spec_helper'

describe MDSIntegration do
  let(:request) do
    {
      request_id: '1234567',
      parameters: sample_credentials
    }
  end

  def json_response
    JSON.parse(last_response.body)
  end

  describe 'POST /add_shipment' do
    let(:request) do
      {
        request_id: '1234567',
        parameters: sample_credentials,
        order: sample_order("R123NEW2")
      }
    end

    it 'returns a notification' do
      VCR.use_cassette("mds_integration_add_shipment") do
        post '/add_shipment', request.to_json, {}

        expect(last_response.status).to eq 200
        expect(json_response["summary"]).to match /was received by MDS Fulfillment./
      end
    end
  end

  describe 'POST /get_shipments' do
    it 'returns a notification' do
      VCR.use_cassette("mds_integration_get_shipments") do
        post '/get_shipments', request.to_json, {}

        expect(last_response.status).to eq 200
        expect(json_response["shipments"][0]["id"]).to eq "R119300"
        expect(json_response["shipments"][0]["status"]).to eq "shipped"
        expect(json_response["shipments"][0]["tracking"]).to eq "TRACK 757874"
      end
    end
  end

  describe 'POST /get_inventory' do
    it 'returns a notification' do
      VCR.use_cassette("mds_integration_get_inventory") do
        post '/get_inventory', request.to_json, {}

        expect(last_response.status).to eq 200
        expect(json_response["inventories"][0]["id"]).to eq "QTRANM03"
        expect(json_response["inventories"][0]["location"]).to eq "MDS"
        expect(json_response["inventories"][0]["product_id"]).to eq "QTRANM03"
        expect(json_response["inventories"][0]["quantity"]).to eq 500
      end
    end
  end
end