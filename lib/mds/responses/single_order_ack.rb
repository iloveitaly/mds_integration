module MDS
  module Responses
    class SingleOrderAck
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

      def objects
        orders = body['OrderDetail'].is_a?(Hash)? [body['OrderDetail']] : Array(body['OrderDetail'])

        orders.map do |order|
          {
            id: order['OrderNumber'],
            email: order['ShipEmailAddress1'],
            shipping_address: {
              firstname: order['Ship_To_Customer_Name'],
              address1: order['Ship_To_Customer_Addr1'],
              address2: order['Ship_To_Customer_Addr2'],
              city: order['Ship_To_Customer_City'],
              state: order['Ship_To_Customer_State'],
              zipcode: order['Ship_To_Customer_Zip'],
              country: order['Ship_To_Customer_Country_Code']
            },
            items: line_items(order)
          }
        end

      end

      private

      def line_items(order)
        line_items = order['Lines']['Line'].is_a?(Hash)? [order['Lines']['Line']] : Array(order['Lines']['Line'])
        line_items.map do |line_item|
          {
            product_id: line_item['sku']
          }
        end
      end
    end
  end
end
