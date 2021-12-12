require "../spec_helper"

Spectator.describe Geode::Vector do
  subject(vector) { Geode::Vector[1, 2, 3] }

  it "stores values for components" do
    aggregate_failures do
      expect(vector[0]).to eq(1)
      expect(vector[1]).to eq(2)
      expect(vector[2]).to eq(3)
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Vector(Int32, 3).zero }

    it "returns a zero vector" do
      aggregate_failures do
        expect(zero[0]).to eq(0)
        expect(zero[1]).to eq(0)
        expect(zero[2]).to eq(0)
      end
    end
  end

  describe "#size" do
    subject { vector.size }

    it "is the correct value" do
      is_expected.to eq(3)
    end
  end

  describe "#to_s" do
    subject { vector.to_s }

    it "contains the components" do
      aggregate_failures do
        is_expected.to contain("1")
        is_expected.to contain("2")
        is_expected.to contain("3")
      end
    end

    it "is formatted correctly" do
      is_expected.to match(/^\(\d+, \d+, \d+\)$/)
    end
  end
end
