require "../spec_helper"

Spectator.describe Geode::Vector2 do
  TOLERANCE = 0.000000000000001

  subject(vector) { Geode::Vector2[1, 2] }

  it "stores values for components" do
    aggregate_failures do
      expect(vector[0]).to eq(1)
      expect(vector[1]).to eq(2)
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Vector2(Int32).zero }

    it "returns a zero vector" do
      expect(zero).to eq(Geode::Vector2[0, 0])
    end
  end

  describe "#size" do
    subject { vector.size }

    it "is the correct value" do
      is_expected.to eq(2)
    end
  end

  describe "#map" do
    it "creates a Vector" do
      mapped = vector.map(&.itself)
      expect(mapped).to be_a(Geode::Vector2(Int32))
    end

    it "uses the new values" do
      mapped = vector.map { |v| v.to_f * 2 }
      expect(mapped).to eq(Geode::Vector2[2.0, 4.0])
    end
  end

  describe "#map_with_index" do
    it "creates a Vector" do
      mapped = vector.map_with_index(&.itself)
      expect(mapped).to be_a(Geode::Vector2(Int32))
    end

    it "uses the new values" do
      mapped = vector.map_with_index { |v, i| v.to_f * i }
      expect(mapped).to eq(Geode::Vector2[0.0, 2.0])
    end

    it "adds the offset" do
      mapped = vector.map_with_index(3) { |v, i| v * i }
      expect(mapped).to eq(Geode::Vector2[3, 8])
    end
  end

  describe "#zip_map" do
    it "iterates two vectors" do
      v1 = Geode::Vector2[5, 8]
      v2 = Geode::Vector2[5, 4]
      result = v1.zip_map(v2) { |a, b| a // b }
      expect(result).to eq(Geode::Vector2[1, 2])
    end
  end

  describe "#to_s" do
    subject { vector.to_s }

    it "contains the components" do
      aggregate_failures do
        is_expected.to contain("1")
        is_expected.to contain("2")
      end
    end

    it "is formatted correctly" do
      is_expected.to match(/^\(\d+, \d+\)$/)
    end
  end

  describe "#to_slice" do
    it "is the size of the vector" do
      slice = vector.to_slice
      expect(slice.size).to eq(2)
    end

    it "contains the components" do
      slice = vector.to_slice
      expect(slice).to eq(Slice[1, 2])
    end
  end

  describe "#to_unsafe" do
    it "references the components" do
      pointer = vector.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(1)
        expect(pointer[1]).to eq(2)
      end
    end
  end

  context Geode::VectorOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Vector2[-5, 42].abs).to eq(Geode::Vector2[5, 42])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Vector2[-5, 3].abs2).to eq(Geode::Vector2[25, 9])
      end
    end

    describe "#round" do
      it "rounds the components" do
        expect(Geode::Vector2[1.2, -5.7].round).to eq(Geode::Vector2[1.0, -6.0])
      end

      context "with digits" do
        it "rounds the components" do
          expect(Geode::Vector2[1.25, -5.77].round(1)).to eq(Geode::Vector2[1.2, -5.8])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each component" do
        expect(Geode::Vector2[5, -5].sign).to eq(Geode::Vector2[1, -1])
      end
    end

    describe "#ceil" do
      it "returns the components rounded up" do
        expect(Geode::Vector2[1.2, -5.7].ceil).to eq(Geode::Vector2[2.0, -5.0])
      end
    end

    describe "#floor" do
      it "returns the components rounded down" do
        expect(Geode::Vector2[1.2, -5.7].floor).to eq(Geode::Vector2[1.0, -6.0])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each component" do
        fraction = Geode::Vector2[1.2, -5.7].fraction
        aggregate_failures do
          expect(fraction[0]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[1]).to be_within(TOLERANCE).of(0.3)
        end
      end
    end

    describe "#clamp" do
      context "with a min and max vectors" do
        it "restricts components" do
          min = Geode::Vector2[-1, -2]
          max = Geode::Vector2[1, 2]
          expect(Geode::Vector2[-2, 3].clamp(min, max)).to eq(Geode::Vector2[-1, 2])
        end
      end

      context "with a range of vectors" do
        it "restricts components" do
          min = Geode::Vector2[-1, -2]
          max = Geode::Vector2[1, 2]
          expect(Geode::Vector2[-2, 3].clamp(min..max)).to eq(Geode::Vector2[-1, 2])
        end
      end

      context "with a min and max" do
        it "restricts components" do
          expect(Geode::Vector2[-2, 3].clamp(-1, 1)).to eq(Geode::Vector2[-1, 1])
        end
      end

      context "with a range" do
        it "restricts components" do
          expect(Geode::Vector2[-2, 3].clamp(-1..1)).to eq(Geode::Vector2[-1, 1])
        end
      end
    end

    describe "#edge" do
      context "with a scalar value" do
        it "returns correct zero and one components" do
          expect(vector.edge(2)).to eq(Geode::Vector2[0, 1])
        end
      end

      context "with a vector" do
        it "returns correct zero and one components" do
          expect(vector.edge(Geode::Vector2[0, 3])).to eq(Geode::Vector2[1, 0])
        end
      end
    end

    describe "#scale" do
      context "with a vector" do
        let(other) { Geode::Vector2[2, 3] }

        it "scales each component separately" do
          expect(vector.scale(other)).to eq(Geode::Vector2[2, 6])
        end
      end

      context "with a scalar" do
        it "scales each component by the same amount" do
          expect(vector.scale(5)).to eq(Geode::Vector2[5, 10])
        end
      end
    end

    describe "#- (negation)" do
      it "negates the vector" do
        expect(-Geode::Vector2[-2, 3]).to eq(Geode::Vector2[2, -3])
      end
    end

    describe "#+" do
      it "adds two vectors" do
        v1 = Geode::Vector2[5, -2]
        v2 = Geode::Vector2[2, -1]
        expect(v1 + v2).to eq(Geode::Vector2[7, -3])
      end
    end

    describe "#-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector2[5, -2]
        v2 = Geode::Vector2[2, -1]
        expect(v1 - v2).to eq(Geode::Vector2[3, -1])
      end
    end

    describe "#*" do
      it "scales a vector" do
        expect(vector * 3).to eq(Geode::Vector2[3, 6])
      end
    end

    describe "#/" do
    let(vector) { Geode::Vector2[6.0, 4.0] }

      it "scales a vector" do
        expect(vector / 2).to eq(Geode::Vector2[3.0, 2.0])
      end
    end

    describe "#//" do
    let(vector) { Geode::Vector2[6, 4] }

      it "scales the vector" do
        expect(vector // 2).to eq(Geode::Vector2[3, 2])
      end
    end
  end

  context Geode::VectorComparison do
    let(v1) { Geode::Vector2[1, 2] }
    let(v2) { Geode::Vector2[3, 2] }

    describe "#compare" do
      it "compares components" do
        expect(v1.compare(v2)).to eq(Geode::Vector2[-1, 0])
      end
    end

    describe "#eq?" do
      it "compares components" do
        expect(v1.eq?(v2)).to eq(Geode::Vector2[false, true])
      end
    end

    describe "#lt?" do
      it "compares components" do
        expect(v1.lt?(v2)).to eq(Geode::Vector2[true, false])
      end
    end

    describe "#le?" do
      it "compares components" do
        expect(v1.le?(v2)).to eq(Geode::Vector2[true, true])
      end
    end

    describe "#gt?" do
      it "compares components" do
        expect(v1.gt?(v2)).to eq(Geode::Vector2[false, false])
      end
    end

    describe "#ge?" do
      it "compares components" do
        expect(v1.ge?(v2)).to eq(Geode::Vector2[false, true])
      end
    end

    describe "#zero?" do
      subject { vector.zero? }

      context "with a zero vector" do
        let(vector) { Geode::Vector2(Int32).zero }

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
        let(vector) { Geode::Vector2[0.1, 0.01] }

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

  context Geode::VectorGeometry do
    TOLERANCE = 0.000000001

    describe "#mag" do
      subject { vector.mag }

      it "returns the magnitude" do
        is_expected.to be_within(TOLERANCE).of(2.236067977)
      end
    end

    describe "#mag2" do
      subject { vector.mag2 }

      it "returns the magnitude squared" do
        is_expected.to eq(5)
      end
    end

    describe "#length" do
      subject { vector.length }

      it "returns the magnitude" do
        is_expected.to be_within(TOLERANCE).of(2.236067977)
      end
    end

    describe "#normalize" do
      subject { vector.normalize }

      it "returns a unit vector" do
        expect(&.mag).to be_within(TOLERANCE).of(1.0)
      end

      it "scales the components equally" do
        scale = 2.236067977
        aggregate_failures do
          expect(vector[0] / subject[0]).to be_within(TOLERANCE).of(scale)
          expect(vector[1] / subject[1]).to be_within(TOLERANCE).of(scale)
        end
      end
    end

    describe "#scale_to" do
      subject { vector.scale_to(5.0) }

      it "returns a vector of the given magnitude" do
        expect(&.mag).to be_within(TOLERANCE).of(5.0)
      end

      it "scales the components equally" do
        scale = 0.447213595
        aggregate_failures do
          expect(vector[0] / subject[0]).to be_within(TOLERANCE).of(scale)
          expect(vector[1] / subject[1]).to be_within(TOLERANCE).of(scale)
        end
      end
    end

    describe "#dot" do
      subject { vector.dot(other) }
      let(other) { Geode::Vector2[10, 20] }

      it "computes the dot-product" do
        is_expected.to eq(50)
      end
    end

    describe "#forward" do
      context "with a same-facing vector" do
        let(surface) { Geode::Vector2[4, 5] }

        it "returns the same vector" do
          expect(vector.forward(surface)).to eq(vector)
        end
      end

      context "with an opposite-facing vector" do
        let(surface) { Geode::Vector2[-4, -5] }

        it "returns a negated vector" do
          expect(vector.forward(surface)).to eq(-vector)
        end
      end
    end

    describe "#reflect" do
      it "computes a reflected vector" do
        incident = Geode::Vector2[2, -1]
        norm = Geode::Vector2[0, 1]
        expect(incident.reflect(norm)).to eq(Geode::Vector2[2.0, 1.0])
      end
    end

    describe "#refract" do
      it "computes a refracted vector" do
        incident = Geode::Vector2[2, -1]
        norm = Geode::Vector2[0, 1]
        expect(incident.refract(norm, 1.5)).to eq(Geode::Vector2[3.0, -1.0])
      end
    end
  end
end
