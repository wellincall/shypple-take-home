# frozen_string_literal: true

require "rails_helper"

RSpec.describe DirectSailings::Sorters::ByArrivalDate do
  describe "#call" do
    
    let(:sorter) { described_class.new }

    describe "comparisons" do
      context "when leg1 arrives sooner than leg2" do
        let(:leg1) { { arrival_date: "2024-01-02" } }
        let(:leg2) { { arrival_date: "2024-01-03" } }

        it "returns -1" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(-1)
        end
      end

      context "when leg1 and leg2 arrive on same day" do
        let(:leg1) { { arrival_date: "2024-01-02" } }
        let(:leg2) { {  arrival_date: "2024-01-02" } }
        it "returns 0" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(0)
        end
      end

      context "when leg1 arrives later than leg2" do
        let(:leg1) { { arrival_date: "2024-02-02" } }
        let(:leg2) { {  arrival_date: "2024-01-02" } }

        it "returns 1" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(1)
        end
      end
    end
  end
end
