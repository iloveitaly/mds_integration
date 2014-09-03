module MDS
  module Services
    module Base
      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        attr_reader :url_package, :xml_root

        def set_url_package(package)
          @url_package = package
        end

        def set_xml_root(xml_root)
          @xml_root = xml_root
        end
      end

      def initialize(credentials)
        @client_code = credentials.fetch(:client_code)
        @client_signature = credentials.fetch(:client_signature)
      end

      def query(object = {})
        puts payload = builder(object).to_xml
        puts '-' * 77
        puts xml_response = HTTParty.get("http://webservice-dev.mdsfulfillment.com/#{self.class.url_package}/ReceiveXML.aspx?xml=" + URI.encode(payload))
        build_response_instance(xml_response)
      end

      def build_response_instance(xml_response)
        response = Hash.from_xml(xml_response)
        klass    = response.keys[0]
        body     = response[klass]

        MDS::Responses.const_get(klass).new(body)
      end

      def xml_builder
        Nokogiri::XML::Builder.new do |xml|
          xml.send(self.class.xml_root, 'xml:lang' => 'en-US') do
            xml.ClientCode @client_code
            xml.ClientSignature @client_signature
            yield(xml)
          end
        end
      end
    end
  end
end