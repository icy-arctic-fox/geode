require "../spec_helper"

Spectator.describe Geode::Vector do
  TOLERANCE = 0.000000000000001

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
      expect(zero).to eq(Geode::Vector[0, 0, 0])
    end
  end

  describe "#size" do
    subject { vector.size }

    it "is the correct value" do
      is_expected.to eq(3)
    end
  end

  describe "#map" do
    it "creates a Vector" do
      mapped = vector.map(&.itself)
      expect(mapped).to be_a(Geode::Vector(Int32, 3))
    end

    it "uses the new values" do
      mapped = vector.map { |v| v.to_f * 2 }
      expect(mapped).to eq(Geode::Vector[2.0, 4.0, 6.0])
    end
  end

  describe "#map_with_index" do
    it "creates a Vector" do
      mapped = vector.map_with_index(&.itself)
      expect(mapped).to be_a(Geode::Vector(Int32, 3))
    end

    it "uses the new values" do
      mapped = vector.map_with_index { |v, i| v.to_f * i }
      expect(mapped).to eq(Geode::Vector[0.0, 2.0, 6.0])
    end

    it "adds the offset" do
      mapped = vector.map_with_index(3) { |v, i| v * i }
      expect(mapped).to eq(Geode::Vector[3, 8, 15])
    end
  end

  describe "#zip_map" do
    it "iterates two vectors" do
      v1 = Geode::Vector[5, 8, 9]
      v2 = Geode::Vector[5, 4, 3]
      result = v1.zip_map(v2) { |a, b| a // b }
      expect(result).to eq(Geode::Vector[1, 2, 3])
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

  describe "#to_slice" do
    it "is the size of the vector" do
      slice = vector.to_slice
      expect(slice.size).to eq(3)
    end

    it "contains the components" do
      slice = vector.to_slice
      expect(slice).to eq(Slice[1, 2, 3])
    end
  end

  describe "#to_unsafe" do
    it "references the components" do
      pointer = vector.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(1)
        expect(pointer[1]).to eq(2)
        expect(pointer[2]).to eq(3)
      end
    end
  end

  context Geode::VectorOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Vector[-5, 42, -20].abs).to eq(Geode::Vector[5, 42, 20])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Vector[-5, 3, -2].abs2).to eq(Geode::Vector[25, 9, 4])
      end
    end

    describe "#round" do
      it "rounds the components" do
        expect(Geode::Vector[1.2, -5.7, 3.0].round).to eq(Geode::Vector[1.0, -6.0, 3.0])
      end

      context "with digits" do
        it "rounds the components" do
          expect(Geode::Vector[1.25, -5.77, 3.01].round(1)).to eq(Geode::Vector[1.2, -5.8, 3.0])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each component" do
        expect(Geode::Vector[5, 0, -5].sign).to eq(Geode::Vector[1, 0, -1])
      end
    end

    describe "#ceil" do
      it "returns the components rounded up" do
        expect(Geode::Vector[1.2, -5.7, 3.0].ceil).to eq(Geode::Vector[2.0, -5.0, 3.0])
      end
    end

    describe "#floor" do
      it "returns the components rounded down" do
        expect(Geode::Vector[1.2, -5.7, 3.0].floor).to eq(Geode::Vector[1.0, -6.0, 3.0])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each component" do
        fraction = Geode::Vector[1.2, -5.7, 3.0].fraction
        aggregate_failures do
          expect(fraction[0]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[1]).to be_within(TOLERANCE).of(0.3)
          expect(fraction[2]).to be_within(TOLERANCE).of(0.0)
        end
      end
    end

    describe "#clamp" do
      context "with a min and max vectors" do
        it "restricts components" do
          min = Geode::Vector[-1, -2, -3]
          max = Geode::Vector[1, 2, 3]
          expect(Geode::Vector[-2, 3, 0].clamp(min, max)).to eq(Geode::Vector[-1, 2, 0])
        end
      end

      context "with a range of vectors" do
        it "restricts components" do
          min = Geode::Vector[-1, -2, -3]
          max = Geode::Vector[1, 2, 3]
          expect(Geode::Vector[-2, 3, 0].clamp(min..max)).to eq(Geode::Vector[-1, 2, 0])
        end
      end

      context "with a min and max" do
        it "restricts components" do
          expect(Geode::Vector[-2, 3, 0].clamp(-1, 1)).to eq(Geode::Vector[-1, 1, 0])
        end
      end

      context "with a range" do
        it "restricts components" do
          expect(Geode::Vector[-2, 3, 0].clamp(-1..1)).to eq(Geode::Vector[-1, 1, 0])
        end
      end
    end

    describe "#- (negation)" do
      it "negates the vector" do
        expect(-Geode::Vector[-2, 3, 0]).to eq(Geode::Vector[2, -3, 0])
      end
    end

    describe "#+" do
      it "adds two vectors" do
        v1 = Geode::Vector[5, -2, 0]
        v2 = Geode::Vector[2, -1, 4]
        expect(v1 + v2).to eq(Geode::Vector[7, -3, 4])
      end
    end

    describe "#-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector[5, -2, 0]
        v2 = Geode::Vector[2, -1, 4]
        expect(v1 - v2).to eq(Geode::Vector[3, -1, -4])
      end
    end

    describe "#*" do
      it "scales a vector" do
        expect(vector * 3).to eq(Geode::Vector[3, 6, 9])
      end
    end

    describe "#/" do
      it "scales a vector" do
        vector = Geode::Vector[6.0, 4.0, 2.0]
        expect(vector / 2).to eq(Geode::Vector[3.0, 2.0, 1.0])
      end
    end

    describe "#//" do
      it "scales the vector" do
        vector = Geode::Vector[6, 4, 2]
        expect(vector // 2).to eq(Geode::Vector[3, 2, 1])
      end
    end
  end

  context Geode::VectorComparison do
    let(v1) { Geode::Vector[1, 2, 3] }
    let(v2) { Geode::Vector[3, 2, 1] }

    describe "#compare" do
      it "compares components" do
        expect(v1.compare(v2)).to eq(Geode::Vector[-1, 0, 1])
      end
    end

    describe "#eq?" do
      it "compares components" do
        expect(v1.eq?(v2)).to eq(Geode::Vector[false, true, false])
      end
    end

    describe "#lt?" do
      it "compares components" do
        expect(v1.lt?(v2)).to eq(Geode::Vector[true, false, false])
      end
    end

    describe "#le?" do
      it "compares components" do
        expect(v1.le?(v2)).to eq(Geode::Vector[true, true, false])
      end
    end

    describe "#gt?" do
      it "compares components" do
        expect(v1.gt?(v2)).to eq(Geode::Vector[false, false, true])
      end
    end

    describe "#ge?" do
      it "compares components" do
        expect(v1.ge?(v2)).to eq(Geode::Vector[false, true, true])
      end
    end

    describe "#zero?" do
      subject { vector.zero? }

      context "with a zero vector" do
        let(vector) { Geode::Vector(Int32, 3).zero }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a non-zero vector" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end

    describe "#near_zero?" do
      subject { vector.near_zero?(0.1) }

      context "with components within tolerance of zero" do
        let(vector) { Geode::Vector[0.1, 0.01, 0.0] }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with components not within tolerance of zero" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end
  end
end
