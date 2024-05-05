# frozen_string_literal: true

require "rails_helper"

RSpec.descrie "Cheapest sailings" do
  describe "GET api/v1/cheapest_sailings" do
    let(:url) { "/api/v1/cheapest_sailings" }
    let(:params) { { origin: "CNSHA", destination: "NLRTM" } }

    it "returns :ok status" do
      get url, params: params

      expect(response).to have_http_status(:ok)
    end

    it "returns cheapest direct sailing" do
      get url, params: params

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response).to eq([
        {
          origin_port: "CNSHA",
          destination_port: "ESBCN",
          departure_date: "2022-01-29",
          arrival_date: "2022-02-06",
          sailing_code: "ERXQ",
          rate: "261.96",
          rate_currency: "USD"
        },
        {
          origin_port: "ESBCN",
          destination_port: "NLRTM",
          departure_date: "2022-02-16",
          arrival_date: "2022-02-20",
          sailing_code: "ERTG",
          rate: "69.96",
          rate_currency: "USD"
        }
      ])
    end

    context "when origin or destination is missing" do
      let(:params) { { origin: "CNSHA" } }

      it "returns :bad_request status" do
        get url, params: params

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when port is not found" do
      let(:params) { { origin: "CNSHA", destination: "NLRTM" } }

      it "returns :not_found status" do
        get url, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
