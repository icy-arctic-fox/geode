require "../spec_helper"

Spectator.describe Geode::Degrees do
  TOLERANCE_VALUE = 0.000000000000001
  TOLERANCE       = Geode::Degrees.new(TOLERANCE_VALUE)

  let(value) { 270.0 }
  subject(angle) { Geode::Degrees.new(value) }

  it "stores the value" do
    expect(angle.value).to eq(value)
  end

  describe ".zero" do
    subject(angle) { Geode::Degrees(Float64).zero }

    it "is a zero angle" do
      expect(angle.value).to eq(0)
    end
  end

  describe ".quarter" do
    subject(angle) { Geode::Degrees(Float64).quarter }

    it "is a quarter of a revolution" do
      expect(angle.value).to eq(90)
    end
  end

  describe ".third" do
    subject(angle) { Geode::Degrees(Float64).third }

    it "is a third of a revolution" do
      expect(angle.value).to eq(120)
    end
  end

  describe ".half" do
    subject(angle) { Geode::Degrees(Float64).half }

    it "is a quarter of a revolution" do
      expect(angle.value).to eq(180)
    end
  end

  describe ".full" do
    subject(angle) { Geode::Degrees(Float64).full }

    it "is a full revolution" do
      expect(angle.value).to eq(360)
    end
  end

  describe "#to_degrees" do
    subject { angle.to_degrees }

    it "returns itself" do
      is_expected.to be(angle)
    end
  end

  describe "#to_radians" do
    subject { angle.to_radians }

    it "converts to radians" do
      is_expected.to be_within(TOLERANCE).of(Geode::Radians.new(Math::PI * 3 / 2))
    end
  end

  describe "#to_turns" do
    subject { angle.to_turns }

    it "converts to turns" do
      is_expected.to be_within(TOLERANCE).of(Geode::Turns.new(0.75))
    end
  end

  describe "#to_s" do
    subject { angle.to_s }

    it "contains the value" do
      is_expected.to contain(value.to_s)
    end

    it "is formatted correctly" do
      is_expected.to match(/^-?(\d+)\.(\d+)°$/)
    end
  end

  describe "#to_f" do
    subject { angle.to_f }

    it "converts to radians and returns the value" do
      is_expected.to eq(Math::PI * 3 / 2)
    end
  end

  describe "#<=>" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).half <=> Geode::Degrees(Float64).half).to eq(0)
          expect(Geode::Degrees(Float64).quarter <=> Geode::Degrees(Float64).third).to eq(-1)
          expect(Geode::Degrees(Float64).third <=> Geode::Degrees(Float64).quarter).to eq(1)
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).half <=> Geode::Radians(Float64).half).to eq(0)
          expect(Geode::Degrees(Float64).quarter <=> Geode::Radians(Float64).third).to eq(-1)
          expect(Geode::Degrees(Float64).third <=> Geode::Turns(Float64).quarter).to eq(1)
        end
      end
    end
  end

  describe "#==" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).half == Geode::Degrees(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half == Geode::Degrees(Float64).zero).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).half == Geode::Radians(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half == Geode::Turns(Float64).zero).to be_false
        end
      end
    end
  end

  describe "#<" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third < Geode::Degrees(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half < Geode::Degrees(Float64).zero).to be_false
          expect(Geode::Degrees(Float64).quarter < Geode::Degrees(Float64).quarter).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third < Geode::Radians(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half < Geode::Radians(Float64).zero).to be_false
          expect(Geode::Degrees(Float64).quarter < Geode::Turns(Float64).quarter).to be_false
        end
      end
    end
  end

  describe "#<=" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third <= Geode::Degrees(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half <= Geode::Degrees(Float64).zero).to be_false
          expect(Geode::Degrees(Float64).quarter <= Geode::Degrees(Float64).quarter).to be_true
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third <= Geode::Radians(Float64).half).to be_true
          expect(Geode::Degrees(Float64).half <= Geode::Radians(Float64).zero).to be_false
          expect(Geode::Degrees(Float64).quarter <= Geode::Turns(Float64).quarter).to be_true
        end
      end
    end
  end

  describe "#>" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third > Geode::Degrees(Float64).half).to be_false
          expect(Geode::Degrees(Float64).half > Geode::Degrees(Float64).zero).to be_true
          expect(Geode::Degrees(Float64).quarter > Geode::Degrees(Float64).quarter).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third > Geode::Radians(Float64).half).to be_false
          expect(Geode::Degrees(Float64).half > Geode::Radians(Float64).zero).to be_true
          expect(Geode::Degrees(Float64).quarter > Geode::Turns(Float64).quarter).to be_false
        end
      end
    end
  end

  describe "#>=" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third >= Geode::Degrees(Float64).half).to be_false
          expect(Geode::Degrees(Float64).half >= Geode::Degrees(Float64).zero).to be_true
          expect(Geode::Degrees(Float64).quarter >= Geode::Degrees(Float64).quarter).to be_true
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Degrees(Float64).third >= Geode::Radians(Float64).half).to be_false
          expect(Geode::Degrees(Float64).half >= Geode::Radians(Float64).zero).to be_true
          expect(Geode::Degrees(Float64).quarter >= Geode::Turns(Float64).quarter).to be_true
        end
      end
    end
  end

  describe "#zero?" do
    subject { angle.zero? }

    context "with a zero angle" do
      let(angle) { Geode::Degrees(Float64).zero }

      it "returns true" do
        is_expected.to be_true
      end
    end

    context "with a non-zero angle" do
      it "returns false" do
        is_expected.to be_false
      end
    end
  end

  describe "#near_zero?" do
    context "with a number" do
      subject { angle.near_zero?(0.1) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Degrees.new(0.01) }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a value not within tolerance of zero" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end

    context "with an angle" do
      subject { angle.near_zero?(Geode::Degrees.new(0.1)) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Degrees.new(0.01) }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a value not within tolerance of zero" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end

    context "with an angle of different type" do
      subject { angle.near_zero?(Geode::Radians.new(0.1)) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Degrees.new(0.01) }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a value not within tolerance of zero" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end
  end

  describe "#positive?" do
    subject { angle.positive? }

    context "with a positive angle" do
      let(angle) { Geode::Degrees.new(45) }

      it "returns true" do
        is_expected.to be_true
      end
    end

    context "with a negative angle" do
      let(angle) { Geode::Degrees.new(-45) }

      it "returns false" do
        is_expected.to be_false
      end
    end
  end

  describe "#negative?" do
    subject { angle.negative? }

    context "with a positive angle" do
      let(angle) { Geode::Degrees.new(45) }

      it "returns false" do
        is_expected.to be_false
      end
    end

    context "with a negative angle" do
      let(angle) { Geode::Degrees.new(-45) }

      it "returns false" do
        is_expected.to be_true
      end
    end
  end

  describe "#acute?" do
    it "returns true for acute angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(0)).to_not be_acute
        expect(Geode::Degrees.new(45)).to be_acute
        expect(Geode::Degrees.new(90)).to_not be_acute
      end
    end
  end

  describe "#right?" do
    it "returns true for right angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(0)).to_not be_right
        expect(Geode::Degrees.new(90)).to be_right
        expect(Geode::Degrees.new(180)).to_not be_right
        expect(Geode::Degrees.new(270)).to_not be_right
      end
    end
  end

  describe "#obtuse?" do
    it "returns true for obtuse angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(90)).to_not be_obtuse
        expect(Geode::Degrees.new(135)).to be_obtuse
        expect(Geode::Degrees.new(180)).to_not be_obtuse
      end
    end
  end

  describe "#straight?" do
    it "returns true for straight angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(0)).to_not be_straight
        expect(Geode::Degrees.new(180)).to be_straight
        expect(Geode::Degrees.new(360)).to_not be_straight
      end
    end
  end

  describe "#reflex?" do
    it "returns true for reflex angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(180)).to_not be_reflex
        expect(Geode::Degrees.new(270)).to be_reflex
        expect(Geode::Degrees.new(360)).to_not be_reflex
      end
    end
  end

  describe "#full?" do
    it "returns true for full angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(0)).to_not be_full
        expect(Geode::Degrees.new(360)).to be_full
        expect(Geode::Degrees.new(720)).to_not be_full
      end
    end
  end

  describe "#oblique?" do
    it "returns true for oblique angles" do
      aggregate_failures do
        expect(Geode::Degrees.new(45)).to be_oblique
        expect(Geode::Degrees.new(90)).to_not be_oblique
        expect(Geode::Degrees.new(180)).to_not be_oblique
        expect(Geode::Degrees.new(360)).to_not be_oblique
      end
    end
  end

  describe "#abs" do
    it "computes the absolute value" do
      aggregate_failures do
        expect(Geode::Degrees.new(90).abs).to eq(Geode::Degrees.new(90))
        expect(Geode::Degrees.new(-90).abs).to eq(Geode::Degrees.new(90))
      end
    end
  end

  describe "#abs2" do
    it "computes the squared value" do
      aggregate_failures do
        expect(Geode::Degrees.new(2).abs2).to eq(Geode::Degrees.new(4))
        expect(Geode::Degrees.new(-3).abs2).to eq(Geode::Degrees.new(9))
      end
    end
  end

  describe "#normalize" do
    it "sets the value between 0 and 360" do
      aggregate_failures do
        expect(Geode::Degrees(Float64).third.normalize).to be_within(TOLERANCE).of(Geode::Degrees(Float64).third)
        expect(Geode::Degrees(Float64).full.normalize).to be_within(TOLERANCE).of(Geode::Degrees(Float64).zero)
        expect(Geode::Degrees.new(540).normalize).to eq(Geode::Degrees.new(180))
        expect(Geode::Degrees.new(-90).normalize).to eq(Geode::Degrees.new(270))
      end
    end
  end

  describe "#signed_normalize" do
    it "sets the value between -180 and +180" do
      aggregate_failures do
        expect(Geode::Degrees(Float64).third.signed_normalize).to be_within(TOLERANCE).of(Geode::Degrees(Float64).third)
        expect(Geode::Degrees(Float64).full.signed_normalize).to be_within(TOLERANCE).of(-Geode::Degrees(Float64).zero)
        expect((-Geode::Degrees(Float64).quarter).signed_normalize).to be_within(TOLERANCE).of(-Geode::Degrees(Float64).quarter)
        expect(Geode::Degrees.new(270).signed_normalize).to eq(-Geode::Degrees(Float64).quarter)
        expect(Geode::Degrees.new(-240).signed_normalize).to eq(Geode::Degrees(Float64).third)
      end
    end
  end

  describe "#round" do
    it "rounds to the nearest whole value" do
      aggregate_failures do
        expect(Geode::Degrees.new(0.1).round).to be_within(TOLERANCE).of(Geode::Degrees.new(0.0))
        expect(Geode::Degrees.new(0.7).round).to be_within(TOLERANCE).of(Geode::Degrees.new(1.0))
      end
    end

    context "with digits" do
      it "rounds to the nearest digit" do
        aggregate_failures do
          expect(Geode::Degrees.new(0.11).round(1)).to be_within(TOLERANCE).of(Geode::Degrees.new(0.1))
          expect(Geode::Degrees.new(0.57).round(1)).to be_within(TOLERANCE).of(Geode::Degrees.new(0.6))
        end
      end
    end
  end

  describe "#sign" do
    it "returns the sign of the angle" do
      aggregate_failures do
        expect(Geode::Degrees.new(-5).sign).to eq(-1)
        expect(Geode::Degrees.new(0).sign).to eq(0)
        expect(Geode::Degrees.new(5).sign).to eq(1)
      end
    end
  end

  describe "#ceil" do
    it "rounds up" do
      aggregate_failures do
        expect(Geode::Degrees.new(1.1).ceil).to be_within(TOLERANCE).of(Geode::Degrees.new(2.0))
        expect(Geode::Degrees.new(1.9).ceil).to be_within(TOLERANCE).of(Geode::Degrees.new(2.0))
      end
    end
  end

  describe "#floor" do
    it "rounds down" do
      aggregate_failures do
        expect(Geode::Degrees.new(1.1).floor).to be_within(TOLERANCE).of(Geode::Degrees.new(1.0))
        expect(Geode::Degrees.new(1.9).floor).to be_within(TOLERANCE).of(Geode::Degrees.new(1.0))
      end
    end
  end

  describe "#fraction" do
    it "returns the fraction" do
      expect(Geode::Degrees.new(1.3).fraction).to be_within(TOLERANCE).of(Geode::Degrees.new(0.3))
    end
  end

  describe "#lerp" do
    let(a1) { Geode::Degrees.new(90) }
    let(a2) { Geode::Degrees.new(270) }

    it "returns a1 when t = 0" do
      angle = a1.lerp(a2, 0.0)
      expect(angle).to be_within(TOLERANCE).of(a1)
    end

    it "returns a2 when t = 1" do
      angle = a1.lerp(a2, 1.0)
      expect(angle).to be_within(TOLERANCE).of(a2)
    end

    it "returns a mid-value" do
      angle = a1.lerp(a2, 0.4)
      expect(angle).to be_within(TOLERANCE).of(Geode::Degrees.new(162))
    end
  end

  describe "#- (negation)" do
    it "negates the angle" do
      aggregate_failures do
        expect(-Geode::Degrees(Float64).quarter).to eq(Geode::Degrees.new(-90))
        expect(-Geode::Degrees.new(180)).to eq(-Geode::Degrees(Float64).half)
      end
    end
  end

  describe "#+" do
    it "adds the angles together" do
      expect(Geode::Degrees.new(30) + Geode::Degrees.new(20)).to eq(Geode::Degrees.new(50))
    end

    context "with a different type of angle" do
      it "adds the angles together" do
        expect(Geode::Degrees(Float64).quarter + Geode::Radians(Float64).half).to be_within(TOLERANCE).of(Geode::Degrees.new(270))
      end

      it "returns degrees" do
        expect(Geode::Degrees(Float64).quarter + Geode::Radians(Float64).half).to be_a(Geode::Degrees(Float64))
      end
    end
  end

  describe "#-" do
    it "subtracts one angle from another" do
      expect(Geode::Degrees.new(50) - Geode::Degrees.new(30)).to eq(Geode::Degrees.new(20))
    end

    context "with a different type of angle" do
      it "subtracts one angle from another" do
        expect(Geode::Degrees.new(270) - Geode::Radians(Float64).half).to be_within(TOLERANCE).of(Geode::Degrees(Float64).quarter)
      end

      it "returns degrees" do
        expect(Geode::Degrees.new(270) - Geode::Radians(Float64).half).to be_a(Geode::Degrees(Float64))
      end
    end
  end

  describe "#*" do
    it "multiples the value" do
      expect(Geode::Degrees(Float64).quarter * 2).to be_within(TOLERANCE).of(Geode::Degrees(Float64).half)
    end
  end

  describe "#/" do
    context "with a number" do
      it "divides the value" do
        expect(Geode::Degrees(Float64).full / 3).to be_within(TOLERANCE).of(Geode::Radians(Float64).third)
      end
    end

    context "with an angle" do
      it "returns the times one angle fits into the other" do
        expect(Geode::Degrees(Float64).full / Geode::Degrees(Float64).third).to be_within(TOLERANCE_VALUE).of(3.0)
      end
    end

    context "with an angle of a different type" do
      it "returns the times one angle fits into the other" do
        expect(Geode::Degrees(Float64).full / Geode::Radians(Float64).quarter).to be_within(TOLERANCE_VALUE).of(4.0)
      end
    end
  end

  describe "#//" do
    context "with a number" do
      it "divides the value using integer division" do
        expect(Geode::Degrees.new(7.0) // 2).to be_within(TOLERANCE).of(Geode::Degrees.new(3.0))
      end
    end

    context "with an angle" do
      it "returns the times one angle fits into the other using integer division" do
        expect(Geode::Degrees.new(7.0) // Geode::Degrees.new(3.0)).to be_within(TOLERANCE_VALUE).of(2.0)
      end
    end

    context "with an angle of a different type" do
      it "returns the times one angle fits into the other using integer division" do
        expect(Geode::Degrees(Float64).full // Geode::Radians.new(Math::PI * 35 / 36)).to be_within(TOLERANCE_VALUE).of(2.0)
      end
    end
  end

  describe "#%" do
    context "with a number" do
      it "returns the remainder of dividing the value" do
        expect(Geode::Degrees.new(7) % 3).to eq(Geode::Degrees.new(1))
      end
    end

    context "with an angle" do
      it "returns the remainder of dividing the angle by another" do
        expect(Geode::Degrees.new(7) % Geode::Degrees.new(3)).to be_within(TOLERANCE_VALUE).of(1)
      end
    end

    context "with an angle of a different type" do
      it "returns the remainder of dividing the angle by another" do
        expect(Geode::Degrees(Float64).full % Geode::Radians.new(Math::PI * 35 / 36)).to be_within(TOLERANCE_VALUE).of(10)
      end
    end
  end
end
