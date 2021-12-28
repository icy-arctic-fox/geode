require "./spec_helper"

Spectator.describe "Geode extension methods" do
  context "angles" do
    describe "Number#degrees" do
      it "returns degrees" do
        expect(30.degrees).to eq(Geode::Degrees.new(30))
      end
    end

    describe "Number#radians" do
      it "returns radians" do
        expect((Math::PI / 2).radians).to eq(Geode::Radians(Float64).quarter)
      end
    end

    describe "Number#turns" do
      it "returns turns" do
        expect(0.5.turns).to eq(Geode::Turns(Float64).half)
      end
    end
  end

  context "vectors" do
    describe "Number#*" do
      it "scales a vector" do
        expect(3 * Geode::Vector[4, 5, 6]).to eq(Geode::Vector[12, 15, 18])
      end
    end
  end
end
