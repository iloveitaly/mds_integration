module MDS
  module Responses
    class ShippingSKUAck
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
        Array(body["Order"]).map do |order|
          {
            id: order["OrderID"],
            status: "shipped",
            tracking: order["TrackingNumber"],
            shipped_at: DateTime.parse(order["OrderShipDate"])
          }
        end
      end
    end
  end
end
