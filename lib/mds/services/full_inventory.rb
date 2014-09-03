module MDS
  module Services
    class FullInventory
      include Base

      set_xml_root    'MDSFullSKU'
      set_url_package 'mds.full.inventory'

      def builder(_)
        xml_builder do |xml|
          xml.SKUDetail 'True'
        end
      end
    end
  end
end
