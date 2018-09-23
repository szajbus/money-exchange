require "spec_helper"

RSpec.describe MoneyExchange::Store do
  let(:now) { Time.now.to_i }

  let(:data) do
    {
      'base' => 'USD',
      'rates' => {
        'EUR' => 0.8,
        'PLN' => 4
      },
      'timestamp' => now
    }
  end

  let(:cached_data) { nil }

  let(:client)      { MoneyExchange::Client::Local.new(data) }
  let(:cache_store) { spy }
  let(:ttl)         { 60 }

  subject do
    allow(cache_store).to receive(:read).with(described_class::CACHE_KEY) { cached_data }

    described_class.new(
      client: client,
      cache_store: cache_store,
      ttl: ttl
    )
  end

  it "defines conversion rates" do
    expect(subject.get_rate('USD', 'EUR')).to eq(0.8)
    expect(subject.get_rate('USD', 'PLN')).to eq(4)
  end

  it "defines inverse conversion rates" do
    expect(subject.get_rate('EUR', 'USD')).to eq(1.25)
    expect(subject.get_rate('PLN', 'USD')).to eq(0.25)
  end

  it "defines transitive conversion rates" do
    expect(subject.get_rate('PLN', 'EUR')).to eq(0.2)
    expect(subject.get_rate('EUR', 'PLN')).to eq(5)
  end

  context "when data is cached" do
    let(:cached_data) do
      {
        'base' => 'USD',
        'rates' => {
          'EUR' => 0.85,
          'PLN' => 3.8
        },
        'timestamp' => now - ttl + 1
      }
    end

    it "uses cached data instead of calling external API" do
      expect(client).not_to receive(:data)
      expect(subject.get_rate('USD', 'PLN')).to eq(3.8)
    end
  end

  context "when data is not cached" do
    it "fetches data from external API and caches it" do
      expect(client).to receive(:data).and_call_original
      expect(cache_store).to \
        receive(:write).with(described_class::CACHE_KEY, data, expires_in: ttl)
      expect(subject.get_rate('USD', 'PLN')).to eq(4)
    end
  end

  context "when data fetched from external API is slightly stale" do
    let(:data) do
      {
        'base' => 'USD',
        'rates' => {
          'EUR' => 0.8,
          'PLN' => 4
        },
        'timestamp' => now - 30
      }
    end

    it "takes data timestamp into account when calculating cache ttl" do
      expect(cache_store).to \
        receive(:write).with(described_class::CACHE_KEY, data, expires_in: ttl - 30)
      expect(subject.get_rate('USD', 'PLN')).to eq(4)
    end
  end
end
