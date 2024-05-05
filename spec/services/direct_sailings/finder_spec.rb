# frozen_string_literal: true

require "rails_helper"

RSpec.describe DirectSailings::Finder do
  let(:mapping) do
    {
      "TEST" => [
        {
          destination_port: "TEST2",
          departure_date: "2023-01-01",
          arrival_date: "2023-01-03",
          sailing_code: "SAIL001",
          rate_currency: "USD",
          cost_in_eur: "1000.0",
          rate: "1100"
        },
        {
          destination_port: "TEST2",
          departure_date: "2023-01-01",
          arrival_date: "2023-01-03",
          sailing_code: "SAIL002",
          rate_currency: "USD",
          cost_in_eur: "500",
          rate: "500"
        }
      ],
      "TEST2" => [
        {
          destination_port: "TEST34",
          departure_date: "2023-01-01",
          arrival_date: "2023-01-03",
          sailing_code: "SAIL034",
          rate_currency: "USD",
          cost_in_eur: "500",
          rate: "500"
        }
      ]
    }
  end

  let(:service) { described_class.new(mapping) }

  describe "#call" do
    it "returns hash with related information about leg" do
      response = service.call("TEST", "TEST2")

      expect(response).to eq({
        origin_port: "TEST",
        destination_port: "TEST2",
        departure_date: "2023-01-01",
        arrival_date: "2023-01-03",
        sailing_code: "SAIL002",
        rate_currency: "USD",
        cost_in_eur: "500",
        rate: "500"
      })
    end

    context "when origin is not present in mapping" do
      it "returns an empty hash" do
        response = service.call("TEST34", "TEST")

        expect(response).to eq({})
      end
    end

    context "when destination not present in mapping" do
      it "returns an empty hash" do
        response = service.call("TEST2", "TEST")

        expect(response).to eq({})
      end
    end
  end
end
