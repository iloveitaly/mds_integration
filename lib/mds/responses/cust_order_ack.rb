module MDS
  module Responses
    class CUSTOrderAck
      attr_accessor :body

      def initialize(body)
        @body = body
      end

      def success?
        body["OrderAck"]["Result"] == "1"
      end

      def message
        if success?
          "#{body["OrderAck"]["OrderID"]} was received by MDS Fulfillment."
        else
          body["OrderAck"]["Message"]
        end
      end
    end
  end
end
