require 'spec_helper'

describe MDS::Services::OrderDetails do
  subject { described_class.new(sample_credentials) }

  describe '#query' do
    it 'returns a success response' do
      VCR.use_cassette('order_details_R123456NEW') do
        response = subject.query %w[R123456NEW]

        expect(response.success?).to eq true
        expect(response.message).to eq '1 orders were received.'
        expect(response.objects).to eq([{ id: 'R123456NEW', email: 'spree@example.com', line_items: [{ product_id: 'QTRZIM03' }] }])
      end
    end

    context 'when orders does not exist' do
      it 'returns a success response' do
        VCR.use_cassette('order_details_not-found') do
          response = subject.query %w[not-found]

          expect(response.success?).to eq true
          expect(response.message).to eq '0 orders were received.'
          expect(response.objects).to eq([])
        end
      end
    end

    context 'when multiple orders' do
      it 'returns a success response' do
        VCR.use_cassette('order_details_R123456NEW_R123_R123NEW21') do
          response = subject.query %w[R123456NEW R123 R123NEW21]


          expect(response.success?).to eq true
          expect(response.message).to eq '2 orders were received.'
          expect(response.objects).to eq([{ id: 'R123456NEW', email: 'spree@example.com', line_items: [{ product_id: 'QTRZIM03' }] },
                                          { id: 'R123NEW21',  email: 'spree@example.com', line_items: [{ product_id: 'QTRZIM03' }] }])
        end
      end
    end
  end
end
