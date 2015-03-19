module MDS
  module Responses
    class ShippingDetailAck
      attr_accessor :body

      def initialize(body)
        @body = body.to_h
      end

      def success?
        true
      end

      def message
        "#{objects.size} shipments were received."
      end

      # wombat shipping documentation: https://support.wombat.co/hc/en-us/articles/202319984-Shipments

      def objects
        orders = body["Order"] || []

        orders.map do |order|
          # TODO this assumes that there is one box per shipment; should check for Hash vs Array to ensure

          order_box = order["Boxes"]["Box"]

          {
            id: order["OrderID"],
            mds_id: order["CadenceID"],
            # TODO does this API return anything aside from 'shipped'?
            status: 'shipped',
            tracking: order_box["TrackingNumber"],
            shipped_at: parse_date(order_box["OrderShipDate"]),
            
            # when a shipment is split, it contains a "-" after the shipment ID. Ex: 774150-1
            # adding a boolean flag allows us to easily adjust the shipment flows to exclude partial shipments
            partial_shipment: order['OrderID'].include?('-'),
            
            items: skus_to_line_items(order_box["SKU"])
          }
        end
      end

      # "SKU"=>
      #  [{"number"=>"1",
      #    "SKUShipped"=>"BWTM-STRPK",
      #    "Lot"=>nil,
      #    "MfgDate"=>nil,
      #    "ExpDate"=>nil,
      #    "Qty"=>"1",
      #    "UPC"=>nil},
      #   {"number"=>"2",
      #    "SKUShipped"=>"GARV-SSBINDER",
      #    "Lot"=>nil,
      #    "MfgDate"=>nil,
      #    "ExpDate"=>nil,
      #    "Qty"=>"1",
      #    "UPC"=>nil}]}}}]}>

      def skus_to_line_items(sku_list)
        sku_list = sku_list.is_a?(Hash) ? [ sku_list ] : sku_list
        sku_list.map do |sku|
          {
            product_id: sku['SKUShipped'],
            quantity: sku['Qty']
          }
        end
      end

      # TODO DRY this up; copied from another response model
      def parse_date(date)
        month, day, year = date.split("/")

        DateTime.new year.to_i, month.to_i, day.to_i
      end
    end
  end
end
