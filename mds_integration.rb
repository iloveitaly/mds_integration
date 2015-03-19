require 'httparty'
require 'nokogiri'

require_relative 'lib/mds/mds'

class MDSIntegration < EndpointBase::Sinatra::Base
  set :logging, true
  
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API']
    config.host    = ENV['AIRBRAKE_HOST'] if ENV['AIRBRAKE_HOST'].present?
    config.port    = ENV['AIRBRAKE_PORT'] if ENV['AIRBRAKE_PORT'].present?
    config.secure  = config.port == 443
  end if ENV['AIRBRAKE_API'].present?
  
  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end if ENV['HONEYBADGER_KEY'].present?

  post '/add_shipment' do
    if @payload[:shipment][:status] == "shipped"
      result 200, "Ignoring shipment #{@payload[:shipment][:id]}, it's already shipped."
    else
      response = MDS::Services::SubmitOrder.new(@config).query(@payload[:shipment])

      result status_from_response(response), response.message
    end
  end

  post '/get_shipments' do
    response = MDS::Services::ShippingStatus::Tracking.new(@config).query

    response.objects.each { |shipment| add_object :shipment, shipment}
    result status_from_response(response), response.message
  end

  post '/get_inventory' do
    response = MDS::Services::FullInventory.new(@config).query

    response.objects.each { |inventory| add_object :inventory, inventory }
    result status_from_response(response), response.message
  end

  post '/get_shipment_details' do
    order_ids = Array(@payload[:shipment][:id])

    response = MDS::Services::OrderDetails.new(@config).query(order_ids)

    response.objects.each { |shipment| add_object :shipment, shipment}

    result status_from_response(response), response.message
  end

  private

  def status_from_response(response)
    response.success?? 200 : 500
  end
end
