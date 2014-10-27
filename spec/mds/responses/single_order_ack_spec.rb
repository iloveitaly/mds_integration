require 'spec_helper'

describe MDS::Responses::SingleOrderAck do
  subject { described_class.new(body) }

  let(:body) do
    Hash.from_xml(xml)['ROOT']
  end

  let(:xml) do
    ''
  end

  describe '#objects' do
  end
end
