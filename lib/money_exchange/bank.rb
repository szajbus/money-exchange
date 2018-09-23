require 'money/bank/variable_exchange'

module MoneyExchange
  class Bank < Money::Bank::VariableExchange
    def initialize(opts = {}, &blk)
      super(MoneyExchange::Store.new(opts), &blk)
    end
  end
end
