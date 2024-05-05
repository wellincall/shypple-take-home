# frozen_string_literal: true

require "rails_helper"

RSpec.describe SailingsMapper do
  describe "#call" do
    let(:service) do
      described_class.new(input)
    end
    let(:input) do
      {
        sailings: [
          { 
            origin_port: "TEST",
            destination_port: "TEST2",
            departure_date: "2023-01-01",
            arrival_date: "2023-01-03",
            sailing_code: "SAIL001"
          },
          { 
            origin_port: "TEST",
            destination_port: "TEST3",
            departure_date: "2023-01-03",
            arrival_date: "2023-01-05",
            sailing_code: "SAIL002"
          },
          { 
            origin_port: "TEST2",
            destination_port: "TEST3",
            departure_date: "2023-01-10",
            arrival_date: "2023-01-15",
            sailing_code: "SAIL003"
          }
        ],
        rates: [
          { sailing_code: "SAIL001", rate: "1100", rate_currency: "USD" },
          { sailing_code: "SAIL002", rate: "100", rate_currency: "EUR" },
          { sailing_code: "SAIL003", rate: "13000", rate_currency: "JPY" }
        ],
        exchange_rates: {
          "2023-01-01" => { "usd" => 1.1, "jpy" => 150 },
          "2023-01-03" => { "usd" => 1.2, "jpy" => 140 },
          "2023-01-10" => { "usd" => 1.15, "jpy" => 130 }
        }
      }
    end

    it "returns a hash with origin ports as keys" do 
      response = service.call

      expect(response.keys).to eq(["TEST", "TEST2"])
    end

    describe "hash values" do
      it "adds a list of destination ports with their corresponding cost in EUR" do
        response = service.call

        aggregate_failures do
          expect(response["TEST"]).to eq([
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
              destination_port: "TEST3",
              departure_date: "2023-01-03",
              arrival_date: "2023-01-05",
              sailing_code: "SAIL002",
              rate_currency: "EUR",
              cost_in_eur: "100",
              rate: "100"
            }
          ])
          expect(response["TEST2"]).to eq([
            {
              destination_port: "TEST3",
              departure_date: "2023-01-10",
              arrival_date: "2023-01-15",
              sailing_code: "SAIL003",
              rate_currency: "JPY",
              cost_in_eur: "100.0",
              rate: "13000"
            }
          ])
        end
      end
    end
  end
end
