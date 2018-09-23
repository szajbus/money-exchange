require 'uri'

module MoneyExchange
  module Client
    class OXR
      ENDPOINT = 'https://openexchangerates.org/api/'.freeze

      def initialize(app_id, iso_base = 'USD')
        @app_id = app_id
        @iso_base = iso_base
      end

      def data
        uri =
          URI.join(ENDPOINT, 'latest.json').tap do |uri|
            uri.query = "app_id=#{@app_id}"
            uri.query += "&base=#{@iso_base}" if @iso_base
          end.to_s

        response = open(uri)
        JSON.parse(response)
      end
    end
  end
end
