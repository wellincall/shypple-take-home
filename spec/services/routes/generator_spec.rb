# frozen_string_literal: true

require "rails_helper"

RSpec.describe Routes::Generator do
  let(:input) do
    {
      "PORT1" => [
        { destination_port: "PORT2" },
        { destination_port: "PORT3" },
        { destination_port: "PORT5" },
      ],
      "PORT2" => [
        { destination_port: "PORT1" },
        { destination_port: "PORT4" },
        { destination_port: "PORT5" },
        { destination_port: "PORT6" },
      ],
      "PORT3" => [
        { destination_port: "PORT4" },
      ],
      "PORT4" => [
        { destination_port: "PORT1" }
      ],
      "PORT5" => [
        { destination_port: "PORT2" }
      ]
    }
  end

  let(:generator) { described_class.new(input) }

  describe "#generate(origin, destination)" do
    it "returns all paths between origin and destination" do
      binding.pry
      response = generator.generate("PORT1", "PORT5")

      expect(response).to eq([
        ["PORT1", "PORT5"],
        ["PORT1", "PORT2", "PORT5"]
      ])
    end

    context "when origin is not found" do
      it "returns an empty list" do
        response = generator.generate("PORT10", "PORT5")

        expect(response).to eq([])
      end
    end

    context "when destination is not found" do
      it "returns an empty list" do
        response = generator.generate("PORT1", "PORT50")

        expect(response).to eq([])
      end
    end
  end
end
