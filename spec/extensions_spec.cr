require "./spec_helper"

Spectator.describe "Geode extension methods" do
  TOLERANCE = 0.000000000000001

  context "angles" do
    describe "Number#degrees" do
      it "returns degrees" do
        expect(30.degrees).to eq(Geode::Degrees.new(30))
      end
    end

    describe "Number#to_degrees" do
      it "converts to degrees" do
        expect(Math::PI.to_degrees).to be_within(TOLERANCE.degrees).of(180.degrees)
      end
    end

    describe "Number#radians" do
      it "returns radians" do
        expect((Math::PI / 2).radians).to eq(Geode::Radians(Float64).quarter)
      end
    end

    describe "Number#to_radians" do
      it "converts to radians" do
        expect(Math::PI.to_radians).to be_within(TOLERANCE.radians).of(Math::PI.radians)
      end
    end

    describe "Number#turns" do
      it "returns turns" do
        expect(0.5.turns).to eq(Geode::Turns(Float64).half)
      end
    end

    describe "Number#to_turns" do
      it "converts to turns" do
        expect(Math::PI.to_turns).to be_within(TOLERANCE.turns).of(0.5.turns)
      end
    end

    describe "Number#gradians" do
      it "returns gradians" do
        expect(200.gradians).to eq(Geode::Gradians(Float64).half)
      end
    end

    describe "Number#to_gradians" do
      it "converts to gradians" do
        expect(Math::PI.to_gradians).to be_within(TOLERANCE.gradians).of(200.gradians)
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
