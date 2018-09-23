module MoneyExchange
  module Client
    class Local
      attr_reader :data

      def initialize(data)
        @data = data
      end
    end
  end
end
