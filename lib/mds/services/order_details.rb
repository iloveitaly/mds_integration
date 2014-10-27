module MDS
  module Services
    class OrderDetails
      include Base

      set_xml_root    'MDSSingleOrderStatus'
      set_url_package 'mds.single.order.status'

      def builder(order_ids)
        order_ids = Array(order_ids)

        xml_builder do |xml|
          order_ids.each { |order_id| xml.Order_Number order_id }
        end
      end
    end
  end
end
