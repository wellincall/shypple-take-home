# frozen_string_literal: true

require "rails_helper"

RSpec.describe DirectSailings::Sorters::ByCost do
  describe "#call" do
    
    let(:sorter) { described_class.new }

    describe "comparisons" do
      context "when leg1 is cheapear than leg2" do
        let(:leg1) { { cost_in_eur: 10 } }
        let(:leg2) { { cost_in_eur: 20 } }

        it "returns -1" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(-1)
        end
      end

      context "when leg1 and leg2 have the same cost" do
        let(:leg1) { { cost_in_eur: 20 } }
        let(:leg2) { { cost_in_eur: 20 } }
        it "returns 0" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(0)
        end
      end

      context "when leg1 is more expensive than leg2" do
        let(:leg1) { { cost_in_eur: 30 } }
        let(:leg2) { { cost_in_eur: 20 } }

        it "returns 1" do
          result = sorter.call(leg1, leg2)

          expect(result).to eq(1)
        end
      end
    end
  end
end
