module MoneyExchange
  module Cache
    class NullStore
      def read(*args)
        nil
      end

      def write(*args)
        nil
      end

      def fetch(*args)
        nil
      end
    end
  end
end
