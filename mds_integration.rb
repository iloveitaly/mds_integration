require 'httparty'
require 'nokogiri'

require_relative 'lib/mds/mds'

class MDSIntegration < EndpointBase::Sinatra::Base
  set :logging, true

  post '/add_shipment' do
    response = MDS::Services::SubmitOrder.new(@config).query(@payload[:shipment])

    result status_from_response(response), response.message
  end

  post '/get_shipments' do
    response = MDS::Services::ShippingStatus::Tracking.new(@config).query

    response.objects.each {|shipment| add_object :shipment, shipment}
    result status_from_response(response), response.message
  end

  post '/get_inventory' do
    response = MDS::Services::FullInventory.new(@config).query

    response.objects.each {|inventory| add_object :inventory, inventory }
    result status_from_response(response), response.message
  end

  def status_from_response(response)
    response.success?? 200 : 500
  end
end
