require 'spec_helper'

describe MDS::Responses::SKUFullAck do
  subject { described_class.new(body) }

  let(:body) do
    Hash.from_xml(xml)["ROOT"]
  end

  let(:xml) do
<<EOF
<ROOT>
  <SKULine>
    <SKU>SKU1</SKU>
    <OnHand>153</OnHand>
    <Active>Y</Active>
  </SKULine>
  <SKULine>
    <SKU>SKU2</SKU>
    <OnHand>99</OnHand>
    <Active>Y</Active>
  </SKULine>
  <SKULine>
    <SKU>SKU3</SKU>
    <OnHand>99</OnHand>
    <Active>Something other than Y</Active>
  </SKULine>
</ROOT>
EOF
  end

  describe '#objects' do
    it 'returns the inventories' do
      expect(subject.objects[0][:product_id]).to eq "SKU1"
      expect(subject.objects[0][:quantity]).to eq 153

      expect(subject.objects[1][:product_id]).to eq "SKU2"
      expect(subject.objects[1][:quantity]).to eq 99
    end

    it 'filters out inactive skus' do
      expect(subject.objects.size).to eq 2
    end
  end
end

