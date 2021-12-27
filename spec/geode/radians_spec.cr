require "../spec_helper"

Spectator.describe Geode::Radians do
  let(value) { Math::PI * 3 / 2 }
  subject(angle) { Geode::Radians(Float64).new(value) }

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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half <=> Geode::Degrees(Float64).half).to eq(0)
          expect(Geode::Radians(Float64).quarter <=> Geode::Degrees(Float64).third).to eq(-1)
          expect(Geode::Radians(Float64).third <=> Geode::Degrees(Float64).quarter).to eq(1)
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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).half == Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half == Geode::Degrees(Float64).zero).to be_false
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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third < Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half < Geode::Degrees(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter < Geode::Degrees(Float64).quarter).to be_false
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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third <= Geode::Degrees(Float64).half).to be_true
          expect(Geode::Radians(Float64).half <= Geode::Degrees(Float64).zero).to be_false
          expect(Geode::Radians(Float64).quarter <= Geode::Degrees(Float64).quarter).to be_true
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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third > Geode::Degrees(Float64).half).to be_false
          expect(Geode::Radians(Float64).half > Geode::Degrees(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter > Geode::Degrees(Float64).quarter).to be_false
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
      xit "compares angles" do
        aggregate_failures do
          expect(Geode::Radians(Float64).third >= Geode::Degrees(Float64).half).to be_false
          expect(Geode::Radians(Float64).half >= Geode::Degrees(Float64).zero).to be_true
          expect(Geode::Radians(Float64).quarter >= Geode::Degrees(Float64).quarter).to be_true
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
      # subject { angle.near_zero?(Geode::Degrees.new(0.1)) }

      context "with a value within tolerance of zero" do
        let(angle) { Geode::Radians.new(0.01) }

        xit "returns true" do
          is_expected.to be_true
        end
      end

      context "with a value not within tolerance of zero" do
        xit "returns false" do
          is_expected.to be_false
        end
      end
    end
  end
end
