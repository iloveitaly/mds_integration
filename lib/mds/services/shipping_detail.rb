module MDS
  module Services
    class ShippingDetail
      include Base

      set_xml_root    'MDSShippingDetail'
      set_url_package 'mds.shipping.detail'

      def initialize(config)
        super

        @number_of_days = config[:number_of_days] || 3
      end

      def builder(_)
        xml_builder do |xml|
          xml.Days @number_of_days.to_s
        end
      end
    end
  end
end
