module MDS
  module Responses
    class SKUFullAck
      attr_accessor :body

      def initialize(body)
        @body = body.to_h
      end

      def success?
        true
      end

      def message
        "Inventory for #{objects.size} products was received."
      end

      def objects
        sku_lines.map do |sku_line|
          {
            id: sku_line["SKU"],
            location: "MDS",
            product_id: sku_line["SKU"],
            quantity: sku_line["OnHand"].to_i
          }
        end
      end

      private
      def sku_lines
        Array(body["SKULine"]).reject {|sku_line| sku_line["Active"] != "Y"}
      end
    end
  end
end
