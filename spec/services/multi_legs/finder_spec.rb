# frozen_string_literal: true

require "rails_helper"

RSpec.describe MultiLegs::Finder do
  let(:paths) do
    [
      ["PORT1", "PORT2"],
      ["PORT1", "PORT3", "PORT2"]
    ]
  end
  let(:sailings) do
    {
      "PORT1" => [
        { 
          destination_port: "PORT2",
          departure_date: "2023-01-03",
          arrival_date: "2023-01-04",
          sailing_code: "SAIL001",
          rate_currency: "EUR",
          cost_in_eur: "100",
          rate: "100"
        },
        { 
          destination_port: "PORT3",
          departure_date: "2023-01-01",
          arrival_date: "2023-01-03",
          sailing_code: "SAIL002",
          rate_currency: "EUR",
          cost_in_eur: "50",
          rate: "100"
        }
      ],
      "PORT2" => [],
      "PORT3" => [
        { 
          destination_port: "PORT2",
          departure_date: "2023-01-04",
          arrival_date: "2023-01-05",
          sailing_code: "SAIL003",
          rate_currency: "EUR",
          cost_in_eur: "25",
          rate: "100"
        }
      ]
    }
  end

  let(:service) { described_class.new(sailings: sailings, paths: paths) }

  describe "#call" do
    it "returns legs that result in lowest cost" do
      response = service.call

      expect(response).to eq(["SAIL002", "SAIL003"])
    end

    context "when cheapest path contains a single leg" do
      let(:sailings) do
        {
          "PORT1" => [
            { 
              destination_port: "PORT2",
              departure_date: "2023-01-03",
              arrival_date: "2023-01-04",
              sailing_code: "SAIL001",
              rate_currency: "EUR",
              cost_in_eur: "10",
              rate: "100"
            },
            { 
              destination_port: "PORT3",
              departure_date: "2023-01-01",
              arrival_date: "2023-01-03",
              sailing_code: "SAIL002",
              rate_currency: "EUR",
              cost_in_eur: "50",
              rate: "100"
            }
          ],
          "PORT2" => [],
          "PORT3" => [
            { 
              destination_port: "PORT2",
              departure_date: "2023-01-04",
              arrival_date: "2023-01-05",
              sailing_code: "SAIL003",
              rate_currency: "EUR",
              cost_in_eur: "25",
              rate: "100"
            }
          ]
        }
      end
      it "returns it in list" do
        response = service.call

        expect(response).to eq(["SAIL001"])
      end
    end

    context "when paths have the same cost" do
      let(:sailings) do
        {
          "PORT1" => [
            { 
              destination_port: "PORT2",
              departure_date: "2023-01-03",
              arrival_date: "2023-01-04",
              sailing_code: "SAIL001",
              rate_currency: "EUR",
              cost_in_eur: "100",
              rate: "100"
            },
            { 
              destination_port: "PORT3",
              departure_date: "2023-01-01",
              arrival_date: "2023-01-03",
              sailing_code: "SAIL002",
              rate_currency: "EUR",
              cost_in_eur: "50",
              rate: "100"
            }
          ],
          "PORT2" => [],
          "PORT3" => [
            { 
              destination_port: "PORT2",
              departure_date: "2023-01-04",
              arrival_date: "2023-01-05",
              sailing_code: "SAIL003",
              rate_currency: "EUR",
              cost_in_eur: "50",
              rate: "100"
            }
          ]
        }
      end

      it "returns the shortest trip" do
        response = service.call

        expect(response).to eq(["SAIL001"])
      end
    end
  end
end
