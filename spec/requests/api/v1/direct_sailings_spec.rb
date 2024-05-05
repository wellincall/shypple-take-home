# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Direct sailings" do
  describe "GET api/v1/direct_sailings" do
    let(:url) { "/api/v1/direct_sailings" }
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
          destination_port: "NLRTM",
          departure_date: "2022-01-30",
          arrival_date: "2022-03-05",
          sailing_code: "MNOP",
          rate: "456.78",
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
      let(:params) { { origin: "BRSSZ", destination: "NLRTM" } }

      it "returns :not_found status" do
        get url, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
