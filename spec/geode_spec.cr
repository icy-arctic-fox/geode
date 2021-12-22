require "./spec_helper"

Spectator.describe Geode do
  TOLERANCE = 0.000000000000001

  describe ".edge" do
    context "with a value smaller than the edge" do
      it "returns 0" do
        expect(described_class.edge(1, 3)).to eq(0)
      end
    end

    context "with a value larger than the edge" do
      it "returns 1" do
        expect(described_class.edge(5, 3)).to eq(1)
      end
    end
  end

  describe ".lerp" do
    it "returns a when t = 0" do
      expect(described_class.lerp(42.0, 123.0, 0.0)).to be_within(TOLERANCE).of(42.0)
    end

    it "returns b when t = 1" do
      expect(described_class.lerp(42.0, 123.0, 1.0)).to be_within(TOLERANCE).of(123.0)
    end

    it "returns a mid-value" do
      expect(described_class.lerp(42.0, 123.0, 0.3)).to be_within(TOLERANCE).of(66.3)
    end

    context "with a vector" do
      let(v1) { Geode::Vector[3.0, 5.0, 7.0] }
      let(v2) { Geode::Vector[23.0, 35.0, 47.0] }

      it "returns v1 when t = 0" do
        vector = described_class.lerp(v1, v2, 0.0)
        aggregate_failures do
          expect(vector[0]).to be_within(TOLERANCE).of(3.0)
          expect(vector[1]).to be_within(TOLERANCE).of(5.0)
          expect(vector[2]).to be_within(TOLERANCE).of(7.0)
        end
      end

      it "returns v2 when t = 1" do
        vector = described_class.lerp(v1, v2, 1.0)
        aggregate_failures do
          expect(vector[0]).to be_within(TOLERANCE).of(23.0)
          expect(vector[1]).to be_within(TOLERANCE).of(35.0)
          expect(vector[2]).to be_within(TOLERANCE).of(47.0)
        end
      end

      it "returns a mid-value" do
        vector = described_class.lerp(v1, v2, 0.4)
        aggregate_failures do
          expect(vector[0]).to be_within(TOLERANCE).of(11.0)
          expect(vector[1]).to be_within(TOLERANCE).of(17.0)
          expect(vector[2]).to be_within(TOLERANCE).of(23.0)
        end
      end
    end
  end
end
