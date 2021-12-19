require "../spec_helper"

Spectator.describe Geode do
  let(v1) { Geode::Vector[3, 5, 7] }
  let(v2) { Geode::Vector[7, 5, 3] }

  describe ".min" do
    context "with two vectors" do
      it "returns the lesser components" do
        expect(Geode.min(v1, v2)).to eq(Geode::Vector[3, 5, 3])
      end
    end

    context "with a vector and value" do
      it "returns the lesser component or value" do
        expect(Geode.min(v1, 5)).to eq(Geode::Vector[3, 5, 5])
      end
    end
  end

  describe ".max" do
    context "with two vectors" do
      it "returns the greater components" do
        expect(Geode.max(v1, v2)).to eq(Geode::Vector[7, 5, 7])
      end
    end

    context "with a vector and value" do
      it "returns the greater component or value" do
        expect(Geode.max(v1, 5)).to eq(Geode::Vector[5, 5, 7])
      end
    end
  end
end
