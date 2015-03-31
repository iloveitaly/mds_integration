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
            xml.OrderDate       DateTime.parse(shipment[:placed_on]).strftime('%F %R')
            xml.ShippingMethod  shipment[:shipping_method]
            xml.Shipname        "#{shipment[:shipping_address][:firstname]} #{shipment[:shipping_address][:lastname]}"
            xml.ShipCompany     shipment[:shipping_address][:company]
            xml.ShipAddress1    shipment[:shipping_address][:address1]
            xml.ShipAddress2    shipment[:shipping_address][:address2]
            xml.ShipCity        shipment[:shipping_address][:city]
            xml.ShipState       shipment[:shipping_address][:state]
            xml.ShipCountry     shipment[:shipping_address][:country]
            xml.ShipZip         shipment[:shipping_address][:zipcode]
            xml.ShipEmail       shipment[:email]
            xml.ShipPhone       shipment[:shipping_address][:phone]

            setup_billing_information(xml, shipment)

            xml.CSEmail         shipment[:email]
            xml.CSPhone         shipment[:shipping_address][:phone]

            setup_totals(xml, shipment[:totals])

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

      def setup_totals(xml, totals)
        totals = totals || {}

        xml.ShippingCharge  totals[:shipping] || 0
        xml.ShippingTax     totals[:tax]      || 0
        xml.ShippingTotal   totals[:shipping] || 0
      end

      def setup_billing_information(xml, shipment)
        billing_address = shipment[:billing_address] || shipment[:shipping_address]

        xml.Billname        "#{billing_address[:firstname]} #{billing_address[:lastname]}"
        xml.BillAddress1    billing_address[:address1]
        xml.BillAddress2    billing_address[:address2]
        xml.BillCity        billing_address[:city]
        xml.BillState       billing_address[:state]
        xml.BillCountry     billing_address[:country]
        xml.BillZip         billing_address[:zipcode]
      end
    end
  end
end