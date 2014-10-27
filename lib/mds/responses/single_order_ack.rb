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
            items: line_items(order)
          }
        end
      end

      private

      def line_items(order)
        line_items = order['Lines'].is_a?(Hash)? [order['Lines']] : Array(order['Lines'])
        line_items.map do |line_item|
          {
            product_id: line_item['Line']['sku']
          }
        end
      end
    end
  end
end
