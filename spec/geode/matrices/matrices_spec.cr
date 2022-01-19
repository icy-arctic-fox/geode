require "../../spec_helper"

Spectator.describe Geode do
  let(m1) { Geode::Matrix[[3, 5, 7], [2, 4, 6]] }
  let(m2) { Geode::Matrix[[7, 5, 3], [6, 4, 2]] }

  describe ".min" do
    context "with two matrices" do
      it "returns the lesser elements" do
        expect(Geode.min(m1, m2)).to eq(Geode::Matrix[[3, 5, 3], [2, 4, 2]])
      end
    end

    context "with a matrix and value" do
      it "returns the lesser element or value" do
        expect(Geode.min(m1, 5)).to eq(Geode::Matrix[[3, 5, 5], [2, 4, 5]])
      end
    end
  end

  describe ".max" do
    context "with two matrices" do
      it "returns the greater elements" do
        expect(Geode.max(m1, m2)).to eq(Geode::Matrix[[7, 5, 7], [6, 4, 6]])
      end
    end

    context "with a matrix and value" do
      it "returns the greater element or value" do
        expect(Geode.max(m1, 5)).to eq(Geode::Matrix[[5, 5, 7], [5, 5, 6]])
      end
    end
  end
end
