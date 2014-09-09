module MDS
  module Services
    class SubmitOrder
      include Base

      set_xml_root    'MDSOrder'
      set_url_package 'mds.order'

      def builder(shipment)
        xml_builder do |xml|
          xml.Order do
            xml.OrderID         shipment[:id]
            xml.ConsumerPONum   shipment[:id]
            xml.OrderDate       shipment[:placed_on]
            xml.ShippingMethod  shipment[:shipping_method]
            xml.Shipname        "#{shipment[:shipping_address][:firstname]} #{shipment[:shipping_address][:lastname]}"
            xml.ShipAddress1    shipment[:shipping_address][:address1]
            xml.ShipAddress2    shipment[:shipping_address][:address2]
            xml.ShipCity        shipment[:shipping_address][:city]
            xml.ShipState       shipment[:shipping_address][:state]
            xml.ShipCountry     shipment[:shipping_address][:country]
            xml.ShipZip         shipment[:shipping_address][:zipcode]
            xml.ShipEmail       shipment[:email]
            xml.ShipPhone       shipment[:shipping_address][:phone]
            xml.Billname        "#{shipment[:billing_address][:firstname]} #{shipment[:billing_address][:lastname]}"
            xml.BillAddress1    shipment[:billing_address][:address1]
            xml.BillAddress2    shipment[:billing_address][:address2]
            xml.BillCity        shipment[:billing_address][:city]
            xml.BillState       shipment[:billing_address][:state]
            xml.BillCountry     shipment[:billing_address][:country]
            xml.BillZip         shipment[:billing_address][:zipcode]
            xml.CSEmail         shipment[:email]
            xml.CSPhone         shipment[:shipping_address][:phone]
            xml.ShippingCharge  shipment[:totals][:shipping]
            xml.ShippingTax     shipment[:totals][:tax]
            xml.ShippingTotal   shipment[:totals][:shipping]

            xml.Lines do
              build_products(xml, shipment)
            end
          end
        end
      end

      def build_products(xml, shipment)
        shipment[:items].each_with_index do |line_item, index|
          xml.Line(number: index + 1) do
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