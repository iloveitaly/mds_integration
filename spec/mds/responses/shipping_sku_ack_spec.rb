require 'spec_helper'

describe MDS::Responses::ShippingSKUAck do
  subject { described_class.new(body) }

  let(:body) do
    Hash.from_xml(xml)["ROOT"]
  end

  let(:xml) do
<<EOF
<ROOT>
  <Order>
    <OrderID>R123</OrderID>
    <OrderShipDate>4/11/2014</OrderShipDate>
    <ServiceType>FedEx SmartPost</ServiceType>
    <TrackingNumber>123TRACKING</TrackingNumber>
    <Weight>0</Weight>
  </Order>
  <Order>
    <OrderID>R456</OrderID>
    <OrderShipDate>4/11/2014</OrderShipDate>
    <ServiceType>FedEx SmartPost</ServiceType>
    <TrackingNumber>1234ABCD</TrackingNumber>
    <Weight>0</Weight>
  </Order>
</ROOT>
EOF
  end

  describe '#objects' do
    it 'returns the shipments' do
      objects = subject.objects

      expect(objects.size).to eq 2
      expect(objects[0][:id]).to eq "R123"
      expect(objects[0][:status]).to eq "shipped"
      expect(objects[0][:tracking]).to eq "123TRACKING"
      expect(objects[0][:shipped_at].month).to eq 11

      expect(objects[1][:id]).to eq "R456"
      expect(objects[1][:status]).to eq "shipped"
      expect(objects[1][:tracking]).to eq "1234ABCD"
      expect(objects[1][:shipped_at].month).to eq 11
    end

    it 'returns a friendly message' do
      expect(subject.message).to eq "2 shipments were received."
    end

    context 'no shippents available' do
      let(:body) { nil }

      it 'returns zero shipments' do
        expect(subject.message).to eq "0 shipments were received."
        expect(subject.objects.size).to eq 0
      end
    end
  end
end

