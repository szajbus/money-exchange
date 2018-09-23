require "money"

RSpec.describe MoneyExchange do
  it "has a version number" do
    expect(MoneyExchange::VERSION).not_to be nil
  end

  describe "money gem integration" do
    before do
      @bank = Money.default_bank
    end

    after do
      Money.default_bank = @bank
    end

    let(:data) do
      {
        'base' => 'USD',
        'rates' => {
          'EUR' => 0.8,
          'PLN' => 4
        },
        'timestamp' => Time.now.to_i
      }
    end

    it "works as default bank" do
      Money.default_bank = MoneyExchange::Bank.new(
        client: MoneyExchange::Client::Local.new(data)
      )

      expect(Money.new(100, 'USD').exchange_to('EUR')).to eq(Money.new(80, 'EUR'))
    end
  end
end
