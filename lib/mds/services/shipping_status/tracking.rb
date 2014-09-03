module MDS
  module Services
    module ShippingStatus
      class Tracking
        include Base

        set_xml_root    'MDSShippingTracking'
        set_url_package 'mds.shipping.Tracking'

        def builder(_)
          xml_builder do |xml|
            xml.Days '100'
          end
        end
      end
    end
  end
end
