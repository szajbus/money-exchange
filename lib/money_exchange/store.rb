require 'money/rates_store/memory'

module MoneyExchange
  class Store < Money::RatesStore::Memory
    CACHE_KEY = 'MoneyExchange::Store/cache'.freeze

    def initialize(opts = {})
      super

      @client      = opts[:client]
      @cache_store = opts[:cache_store]
      @ttl         = opts[:ttl] || 24 * 60 * 60
      @loaded_at   = nil
      @iso_base    = nil
    end

    def get_rate(iso_from, iso_to)
      load_rates! if stale?

      super || begin
        rate =
          if iso_from == @iso_base
            nil
          elsif inverse_rate = super(iso_to, iso_from)
            1.0 / inverse_rate
          elsif iso_to == @iso_base
            nil
          else
            get_rate(iso_from, @iso_base) * get_rate(@iso_base, iso_to)
          end

        add_rate(iso_from, iso_to, rate)
      end
    end

    private

    def load_rates!
      data = @cache_store.read(CACHE_KEY)

      unless data
        data = @client.data

        expires_in = data['timestamp'] + @ttl - Time.now.to_i
        @cache_store.write(CACHE_KEY, data, expires_in: expires_in)
      end

      @iso_base = data['base']

      transaction do
        index.clear
        data['rates'].each do |iso_to, rate|
          add_rate(@iso_base, iso_to, rate)
        end
      end

      @loaded_at = Time.now.to_i
    end

    def stale?
      @loaded_at.nil? || (@loaded_at + @ttl < Time.now.to_i)
    end
  end
end
