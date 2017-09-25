# -*- encoding : utf-8 -*-

module BingAdsApi
  class AdGroupPerformanceReportRequest < BingAdsApi::PerformanceReportRequest

    # Valid Columns for this report request
    COLUMNS = BingAdsApi::Config.instance.
      reporting_constants['ad_group_performance_report']['columns']

    # Valid Filters for this report request
    FILTERS = BingAdsApi::Config.instance.
      reporting_constants['ad_group_performance_report']['filter']

    def initialize(attributes={})
      raise Exception.new("Invalid columns") if !valid_columns(COLUMNS, attributes[:columns])
      raise Exception.new("Invalid filters") if !valid_filter(FILTERS, attributes[:filter])
      raise Exception.new("Invalid scope") if !valid_scope(attributes[:scope])
      super(attributes)
    end


    # Public:: Returns the object as a Hash valid for SOAP requests
    #
    # Author:: jlopezn@neonline.cl
    #
    # === Parameters
    # * +keys_case+ - case for the hashes keys: underscore or camelcase
    #
    # Returns:: Hash
    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[get_attribute_key('columns', keys)] =
        columns_to_hash(COLUMNS, columns, keys)
      if filter
        hash[get_attribute_key('filter', keys)] =
          filter_to_hash(FILTERS, keys)
      end
      hash[get_attribute_key('scope', keys)] = scope_to_hash(keys)
      hash["@xsi:type"] = type_attribute_for_soap
      return hash.compact
    end


    private

      # Internal:: Validates the scope attribute given in the constructor
      #
      # Author:: jlopezn@neonline.cl
      #
      # === Parameters
      # * +scope+ - value for the 'scope' key in the has initializer
      #
      # Returns:: true if the scope specification is valid. Raises Exception otherwise
      #
      # Raises:: Exception if the scope is not valid
      def valid_scope(scope)
        raise Exception.new("Invalid scope: no account_ids key") if !scope.key?(:account_ids)
        # raise Exception.new("Invalid scope: no campaigns key") if !scope.key?(:campaigns)
        return true
      end


      # Internal:: Returns the scope attribute as a hash for the SOAP request
      #
      # Author:: jlopezn@neonline.cl
      #
      # === Parameters
      # * +keys_case+ - case for the hash: underscore or camelcase
      #
      # Returns:: Hash
      def scope_to_hash(keys_case=:underscore)
        hash = { get_attribute_key('account_ids', keys_case) => {"ins0:long" => object_to_hash(scope[:account_ids], keys_case)} }
        return hash unless scope[:campaigns]
        hash.merge(get_attribute_key('campaigns', keys_case) =>
            { "AccountThroughAdGroupReportScope" => object_to_hash(scope[:campaigns], keys_case) })
      end

      # Internal:: Returns a string with type attribute for the ReportRequest SOAP tag
      #
      # Author:: jlopezn@neonline.cl
      #
      # Returns:: "v9:CampaignPerformanceReportRequest"
      def type_attribute_for_soap
        return BingAdsApi::ClientProxy::NAMESPACE.to_s + ":" +
          BingAdsApi::Config.instance.
            reporting_constants['ad_group_performance_report']['type']
      end
  end
end