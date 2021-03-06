require "../../spec_helper"

Spectator.describe Geode::Radians do
  TOLERANCE_VALUE = 0.000000000000001
  TOLERANCE       = Geode::Radians.new(TOLERANCE_VALUE)

  let(value) { Math::PI * 3 / 2 }
  subject(angle) { Geode::Radians.new(value) }

  it "stores the value" do
    expect(angle.value).to eq(value)
  end

  describe ".zero" do
    subject(angle) { Geode::Radians(Float64).zero }

    it "is a zero angle" do
      expect(angle.value).to eq(0)
    end
  end

  describe ".quarter" do
    subject(angle) { Geode::Radians(Float64).quarter }

    it "is a quarter of a revolution" do
      expect(angle.value).to eq(Math::PI / 2)
    end
  end

  describe ".third" do
    subject(angle) { Geode::Radians(Float64).third }

    it "is a third of a revolution" do
      expect(angle.value).to eq(Math::TAU / 3)
    end
  end

  describe ".half" do
    subject(angle) { Geode::Radians(Float64).half }

    it "is a quarter of a revolution" do
      expect(angle.value).to eq(Math::PI)
    end
  end

  describe ".full" do
    subject(angle) { Geode::Radians(Float64).full }

    it "is a full revolution" do
      expect(angle.value).to eq(Math::TAU)
    end
  end

  describe "#to_radians" do
    subject { angle.to_radians }

    it "returns itself" do
      is_expected.to be(angle)
    end
  end

  describe "#to_degrees" do
    subject { angle.to_degrees }

    it "converts to degrees" do
      is_expected.to be_within(TOLERANCE).of(Geode::Degrees.new(270))
    end
  end

  describe "#to_turns" do
    subject { angle.to_turns }

    it "converts to turns" do
      is_expected.to be_within(TOLERANCE).of(Geode::Turns.new(0.75))
    end
  end

  describe "#to_gradians" do
    subject { angle.to_gradians }

    it "converts to gradians" do
      is_expected.to be_within(TOLERANCE).of(Geode::Gradians.new(300))
    end
  end

  describe "#to_s" do
    subject { angle.to_s }

    it "contains the value" do
      is_expected.to contain(value.to_s)
    end

    it "is formatted correctly" do
      is_expected.to match(/^-?(\d+)\.(\d+) rad$/)
    end
  end

  describe "#to_f" do
    subject { angle.to_f }

    it "returns the underlying value" do
      is_expected.to eq(value)
    end
  end

  describe "#to_unsafe" do
    subject { angle.to_unsafe }

    it "returns the underlying value" do
      is_expected.to eq(value)
    end
  end

  describe "#<=>" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half <=> Geode::Radians(Float64).half).to eq(0)
          expect(Geode::Radians(Float64).quarter <=> Geode::Radians(Float64).third).to eq(-1)
          expect(Geode::Radians(Float64).third <=> Geode::Radians(Float64).quarter).to eq(1)
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half <=> Geode::Degrees(Float64).half).to eq(0)
          expect(Geode::Radians(Float64).quarter <=> Geode::Gradians(Float64).third).to eq(-1)
          expect(Geode::Radians(Float64).third <=> Geode::Turns(Float64).quarter).to eq(1)
        end
      end
    end
  end

  describe "#==" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half == Geode::Radians(Float64).half).to be_true
          expect(Geode::Radians(Float64).half == Geode::Radians(Float64).zero).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half == Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half == Geode::Turns(Float64).zero).to be_false
        end
      end
    end
  end

  describe "#<" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third < Geode::Radians(Float64).half).to be_true
          expect(Geode::Radians(Float64).half < Geode::Radians(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter < Geode::Radians(Float64).quarter).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third < Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half < Geode::Gradians(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter < Geode::Turns(Float64).quarter).to be_false
        end
      end
    end
  end

  describe "#<=" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third <= Geode::Radians(Float64).half).to be_true
          expect(Geode::Radians(Float64).half <= Geode::Radians(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter <= Geode::Radians(Float64).quarter).to be_true
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third <= Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half <= Geode::Gradians(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter <= Geode::Turns(Float64).quarter).to be_true
        end
      end
    end
  end

  describe "#>" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third > Geode::Radians(Float64).half).to be_false
          expect(Geode::Radians(Float64).half > Geode::Radians(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter > Geode::Radians(Float64).quarter).to be_false
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third > Geode::Degrees(Float64).half).to be_false
          expect(Geode::Radians(Float64).half > Geode::Gradians(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter > Geode::Turns(Float64).quarter).to be_false
        end
      end
    end
  end

  describe "#>=" do
    context "with an angle of the same type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third >= Geode::Radians(Float64).half).to be_false
          expect(Geode::Radians(Float64).half >= Geode::Radians(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter >= Geode::Radians(Float64).quarter).to be_true
        end
      end
    end

    context "with an angle of a different type" do
      it "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third >= Geode::Degrees(Float64).half).to be_false
          expect(Geode::Radians(Float64).half >= Geode::Gradians(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter >= Geode::Turns(Float64).quarter).to be_true
        end
      end
    end
  end

  describe "#zero?" do
    subject { angle.zero? }

    context "with a zero angle" do
      let(angle) { Geode::Radians(Float64).zero }

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
        let(angle) { Geode::Radians.new(0.01) }

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
      subject { angle.near_zero?(Geode::Radians.new(0.1)) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Radians.new(0.01) }

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
      subject { angle.near_zero?(Geode::Degrees.new(0.1)) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Radians.new(0.001) }

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
      let(angle) { Geode::Radians.new(Math::PI / 4) }

      it "returns true" do
        is_expected.to be_true
      end
    end

    context "with a negative angle" do
      let(angle) { Geode::Radians.new(Math::PI / -4) }

      it "returns false" do
        is_expected.to be_false
      end
    end
  end

  describe "#negative?" do
    subject { angle.negative? }

    context "with a positive angle" do
      let(angle) { Geode::Radians.new(Math::PI / 4) }

      it "returns false" do
        is_expected.to be_false
      end
    end

    context "with a negative angle" do
      let(angle) { Geode::Radians.new(Math::PI / -4) }

      it "returns false" do
        is_expected.to be_true
      end
    end
  end

  describe "#acute?" do
    it "returns true for acute angles" do
      aggregate_failures do
        expect(Geode::Radians.new(0.0)).to_not be_acute
        expect(Geode::Radians.new(Math::PI / 4)).to be_acute
        expect(Geode::Radians.new(Math::PI / 2)).to_not be_acute
      end
    end
  end

  describe "#right?" do
    it "returns true for right angles" do
      aggregate_failures do
        expect(Geode::Radians.new(0.0)).to_not be_right
        expect(Geode::Radians.new(Math::PI / 2)).to be_right
        expect(Geode::Radians.new(Math::PI)).to_not be_right
        expect(Geode::Radians.new(Math::PI * 3 / 2)).to_not be_right
      end
    end
  end

  describe "#obtuse?" do
    it "returns true for obtuse angles" do
      aggregate_failures do
        expect(Geode::Radians.new(Math::PI / 2)).to_not be_obtuse
        expect(Geode::Radians.new(Math::PI * 3 / 4)).to be_obtuse
        expect(Geode::Radians.new(Math::PI)).to_not be_obtuse
      end
    end
  end

  describe "#straight?" do
    it "returns true for straight angles" do
      aggregate_failures do
        expect(Geode::Radians.new(0.0)).to_not be_straight
        expect(Geode::Radians.new(Math::PI)).to be_straight
        expect(Geode::Radians.new(Math::TAU)).to_not be_straight
      end
    end
  end

  describe "#reflex?" do
    it "returns true for reflex angles" do
      aggregate_failures do
        expect(Geode::Radians.new(Math::PI)).to_not be_reflex
        expect(Geode::Radians.new(Math::PI * 3 / 2)).to be_reflex
        expect(Geode::Radians.new(Math::TAU)).to_not be_reflex
      end
    end
  end

  describe "#full?" do
    it "returns true for full angles" do
      aggregate_failures do
        expect(Geode::Radians.new(0.0)).to_not be_full
        expect(Geode::Radians.new(Math::TAU)).to be_full
        expect(Geode::Radians.new(Math::TAU * 2)).to_not be_full
      end
    end
  end

  describe "#oblique?" do
    it "returns true for oblique angles" do
      aggregate_failures do
        expect(Geode::Radians.new(Math::PI / 4)).to be_oblique
        expect(Geode::Radians.new(Math::PI / 2)).to_not be_oblique
        expect(Geode::Radians.new(Math::PI)).to_not be_oblique
        expect(Geode::Radians.new(Math::TAU)).to_not be_oblique
      end
    end
  end

  describe "#abs" do
    it "computes the absolute value" do
      aggregate_failures do
        expect(Geode::Radians.new(Math::PI / 2).abs).to eq(Geode::Radians.new(Math::PI / 2))
        expect(Geode::Radians.new(-Math::PI / 2).abs).to eq(Geode::Radians.new(Math::PI / 2))
      end
    end
  end

  describe "#abs2" do
    it "computes the squared value" do
      aggregate_failures do
        expect(Geode::Radians.new(2).abs2).to eq(Geode::Radians.new(4))
        expect(Geode::Radians.new(-3).abs2).to eq(Geode::Radians.new(9))
      end
    end
  end

  describe "#normalize" do
    it "sets the value between 0 and 2 pi" do
      aggregate_failures do
        expect(Geode::Radians(Float64).third.normalize).to be_within(TOLERANCE).of(Geode::Radians(Float64).third)
        expect(Geode::Radians(Float64).full.normalize).to be_within(TOLERANCE).of(Geode::Radians(Float64).zero)
        expect(Geode::Radians.new(Math::PI * 3).normalize).to be_within(TOLERANCE).of(Geode::Radians.new(Math::PI))
        expect(Geode::Radians.new(-Math::PI / 2).normalize).to be_within(TOLERANCE).of(Geode::Radians.new(Math::PI * 3 / 2))
      end
    end
  end

  describe "#signed_normalize" do
    it "sets the value between -pi and +pi" do
      aggregate_failures do
        expect(Geode::Radians(Float64).third.signed_normalize).to be_within(TOLERANCE).of(Geode::Radians(Float64).third)
        expect(Geode::Radians(Float64).full.signed_normalize).to be_within(TOLERANCE).of(-Geode::Radians(Float64).zero)
        expect((-Geode::Radians(Float64).quarter).signed_normalize).to be_within(TOLERANCE).of(-Geode::Radians(Float64).quarter)
        expect(Geode::Radians.new(Math::PI * 3 / 2).signed_normalize).to be_within(TOLERANCE).of(-Geode::Radians(Float64).quarter)
        expect(Geode::Radians.new(Math::PI * -4 / 3).signed_normalize).to be_within(TOLERANCE).of(Geode::Radians(Float64).third)
      end
    end
  end

  describe "#round" do
    it "rounds to the nearest whole value" do
      aggregate_failures do
        expect(Geode::Radians.new(0.1).round).to be_within(TOLERANCE).of(Geode::Radians.new(0.0))
        expect(Geode::Radians.new(0.7).round).to be_within(TOLERANCE).of(Geode::Radians.new(1.0))
      end
    end

    context "with digits" do
      it "rounds to the nearest digit" do
        aggregate_failures do
          expect(Geode::Radians.new(0.11).round(1)).to be_within(TOLERANCE).of(Geode::Radians.new(0.1))
          expect(Geode::Radians.new(0.57).round(1)).to be_within(TOLERANCE).of(Geode::Radians.new(0.6))
        end
      end
    end
  end

  describe "#sign" do
    it "returns the sign of the angle" do
      aggregate_failures do
        expect(Geode::Radians.new(-5).sign).to eq(-1)
        expect(Geode::Radians.new(0).sign).to eq(0)
        expect(Geode::Radians.new(5).sign).to eq(1)
      end
    end
  end

  describe "#ceil" do
    it "rounds up" do
      aggregate_failures do
        expect(Geode::Radians.new(1.1).ceil).to be_within(TOLERANCE).of(Geode::Radians.new(2.0))
        expect(Geode::Radians.new(1.9).ceil).to be_within(TOLERANCE).of(Geode::Radians.new(2.0))
      end
    end
  end

  describe "#floor" do
    it "rounds down" do
      aggregate_failures do
        expect(Geode::Radians.new(1.1).floor).to be_within(TOLERANCE).of(Geode::Radians.new(1.0))
        expect(Geode::Radians.new(1.9).floor).to be_within(TOLERANCE).of(Geode::Radians.new(1.0))
      end
    end
  end

  describe "#fraction" do
    it "returns the fraction" do
      expect(Geode::Radians.new(1.3).fraction).to be_within(TOLERANCE).of(Geode::Radians.new(0.3))
    end
  end

  describe "#lerp" do
    let(a1) { Geode::Radians.new(Math::PI / 2) }
    let(a2) { Geode::Radians.new(Math::PI * 3 / 2) }

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
      expect(angle).to be_within(TOLERANCE).of(Geode::Radians.new(Math::PI * 0.9))
    end
  end

  describe "#- (negation)" do
    it "negates the angle" do
      aggregate_failures do
        expect(-Geode::Radians(Float64).quarter).to eq(Geode::Radians.new(Math::PI / -2))
        expect(-Geode::Radians.new(Math::PI)).to eq(-Geode::Radians(Float64).half)
      end
    end
  end

  describe "#+" do
    it "adds the angles together" do
      expect(Geode::Radians.new(0.3) + Geode::Radians.new(0.2)).to be_within(TOLERANCE).of(Geode::Radians.new(0.5))
    end

    context "with a different type of angle" do
      it "adds the angles together" do
        expect(Geode::Radians(Float64).quarter + Geode::Degrees(Float64).half).to be_within(TOLERANCE).of(Geode::Radians.new(Math::PI * 3 / 2))
      end

      it "returns radians" do
        expect(Geode::Radians(Float64).quarter + Geode::Degrees(Float64).half).to be_a(Geode::Radians(Float64))
      end
    end
  end

  describe "#&+" do
    it "adds the angles together" do
      expect(Geode::Radians.new(3) &+ Geode::Radians.new(2)).to be_within(TOLERANCE).of(Geode::Radians.new(5))
    end
  end

  describe "#-" do
    it "subtracts one angle from another" do
      expect(Geode::Radians.new(0.5) - Geode::Radians.new(0.3)).to be_within(TOLERANCE).of(Geode::Radians.new(0.2))
    end

    context "with a different type of angle" do
      it "subtracts one angle from another" do
        expect(Geode::Radians.new(Math::PI * 3 / 2) - Geode::Degrees(Float64).half).to be_within(TOLERANCE).of(Geode::Radians(Float64).quarter)
      end

      it "returns radians" do
        expect(Geode::Radians.new(Math::PI * 3 / 2) - Geode::Degrees(Float64).half).to be_a(Geode::Radians(Float64))
      end
    end
  end

  describe "#&-" do
    it "subtracts one angle from another" do
      expect(Geode::Radians.new(5) &- Geode::Radians.new(3)).to be_within(TOLERANCE).of(Geode::Radians.new(2))
    end
  end

  describe "#*" do
    it "multiples the value" do
      expect(Geode::Radians(Float64).quarter * 2).to be_within(TOLERANCE).of(Geode::Radians(Float64).half)
    end
  end

  describe "#&*" do
    it "multiples the value" do
      expect(Geode::Radians.new(3) &* 2).to eq(Geode::Radians.new(6))
    end
  end

  describe "#/" do
    context "with a number" do
      it "divides the value" do
        expect(Geode::Radians(Float64).full / 3).to be_within(TOLERANCE).of(Geode::Radians(Float64).third)
      end
    end

    context "with an angle" do
      it "returns the times one angle fits into the other" do
        expect(Geode::Radians(Float64).full / Geode::Radians(Float64).third).to be_within(TOLERANCE_VALUE).of(3.0)
      end
    end

    context "with an angle of a different type" do
      it "returns the times one angle fits into the other" do
        expect(Geode::Radians(Float64).full / Geode::Degrees(Float64).quarter).to be_within(TOLERANCE_VALUE).of(4.0)
      end
    end
  end

  describe "#//" do
    context "with a number" do
      it "divides the value using integer division" do
        expect(Geode::Radians.new(7.0) // 2).to be_within(TOLERANCE).of(Geode::Radians.new(3.0))
      end
    end

    context "with an angle" do
      it "returns the times one angle fits into the other using integer division" do
        expect(Geode::Radians.new(7.0) // Geode::Radians.new(3.0)).to be_within(TOLERANCE_VALUE).of(2.0)
      end
    end

    context "with an angle of a different type" do
      it "returns the times one angle fits into the other using integer division" do
        expect(Geode::Radians(Float64).full // Geode::Degrees.new(85.0)).to be_within(TOLERANCE_VALUE).of(4.0)
      end
    end
  end

  describe "#%" do
    context "with a number" do
      it "returns the remainder of dividing the value" do
        expect(Geode::Radians.new(7) % 3).to eq(Geode::Radians.new(1))
      end
    end

    context "with an angle" do
      it "returns the remainder of dividing the angle by another" do
        expect(Geode::Radians.new(7) % Geode::Radians.new(3)).to be_within(TOLERANCE_VALUE).of(1)
      end
    end

    context "with an angle of a different type" do
      it "returns the remainder of dividing the angle by another" do
        expect(Geode::Radians(Float64).full % Geode::Degrees.new(85.0)).to be_within(TOLERANCE_VALUE).of(20 / 180 * Math::PI)
      end
    end
  end

  describe "#step" do
    subject { angle.step(to: Geode::Radians(Float64).full, by: Geode::Radians.new(Math::PI / 4)) }

    let(values) do
      [Math::PI * 3 / 2, Math::PI * 7 / 4, Math::TAU].map { |v| Geode::Radians.new(v) }
    end

    it "iterates over angles" do
      is_expected.to match_array(values)
    end
  end
end
