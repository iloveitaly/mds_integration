module MDS
  module Services
    class SubmitOrder
      include Base

      set_xml_root    'MDSOrder'
      set_url_package 'mds.order'

      def builder(order)
        xml_builder do |xml|
          xml.Order do
            xml.OrderID         order[:id]
            xml.ConsumerPONum   order[:id]
            xml.OrderDate       order[:placed_on]
            xml.ShippingMethod  order[:shipping_method]
            xml.Shipname        "#{order[:shipping_address][:firstname]} #{order[:shipping_address][:lastname]}"
            xml.ShipAddress1    order[:shipping_address][:address1]
            xml.ShipAddress2    order[:shipping_address][:address2]
            xml.ShipCity        order[:shipping_address][:city]
            xml.ShipState       order[:shipping_address][:state]
            xml.ShipCountry     order[:shipping_address][:country]
            xml.ShipZip         order[:shipping_address][:zipcode]
            xml.ShipEmail       order[:email]
            xml.ShipPhone       order[:shipping_address][:phone]
            xml.Billname        "#{order[:billing_address][:firstname]} #{order[:billing_address][:lastname]}"
            xml.BillAddress1    order[:billing_address][:address1]
            xml.BillAddress2    order[:billing_address][:address2]
            xml.BillCity        order[:billing_address][:city]
            xml.BillState       order[:billing_address][:state]
            xml.BillCountry     order[:billing_address][:country]
            xml.BillZip         order[:billing_address][:zipcode]
            xml.CSEmail         order[:email]
            xml.CSPhone         order[:shipping_address][:phone]
            xml.ShippingCharge  order[:totals][:shipping]
            xml.ShippingTax     order[:totals][:tax]
            xml.ShippingTotal   order[:totals][:shipping]

            xml.Lines do
              build_products(xml, order)
            end
          end
        end
      end

      def build_products(xml, order)
        order[:line_items].each_with_index do |line_item, index|
          xml.Line(number: index) do
            xml.RetailerItemID  line_item[:product_id]
            xml.CUSTItemID      line_item[:product_id]
            xml.UPC             line_item[:product_id]
            xml.Qty             line_item[:quantity]
            xml.PricePerUnit    line_item[:price]
          end
        end
      end
    end
  end
end