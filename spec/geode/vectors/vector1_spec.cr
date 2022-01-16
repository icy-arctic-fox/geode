require "../../spec_helper"

Spectator.describe Geode::Vector1 do
  TOLERANCE = 0.000000000000001

  subject(vector) { Geode::Vector1[42] }

  describe ".[]" do
    it "stores values for components" do
      expect(vector).to have_attributes(x: 42)
    end
  end

  describe ".new" do
    context "individual components" do
      it "stores values for components" do
        vector = described_class.new(42)
        expect(vector).to have_attributes(x: 42)
      end
    end

    context "Tuple" do
      it "stores values for components" do
        vector = described_class.new({42})
        expect(vector).to have_attributes(x: 42)
      end
    end

    context "StaticArray" do
      it "stores values for components" do
        array = StaticArray[42]
        vector = described_class.new(array)
        expect(vector).to have_attributes(x: 42)
      end
    end

    context "another vector" do
      it "stores values for components" do
        other = Geode::Vector[42]
        vector = described_class.new(other)
        expect(vector).to have_attributes(x: 42)
      end
    end

    context "block" do
      it "stores values for components" do
        vector = Geode::Vector1(Int32).new { |i| i + 1 }
        expect(vector).to have_attributes(x: 1)
      end
    end
  end

  describe "#tuple" do
    subject { vector.tuple }

    it "returns a tuple containing the components" do
      is_expected.to eq({42})
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Vector1(Int32).zero }

    it "returns a zero vector" do
      expect(zero).to eq(Geode::Vector1[0])
    end
  end

  describe "#size" do
    subject { vector.size }

    it "is the correct value" do
      is_expected.to eq(1)
    end
  end

  describe "#map" do
    it "creates a Vector" do
      mapped = vector.map(&.itself)
      expect(mapped).to be_a(Geode::Vector1(Int32))
    end

    it "uses the new values" do
      mapped = vector.map { |v| v.to_f / 2 }
      expect(mapped).to eq(Geode::Vector1[21.0])
    end
  end

  describe "#map_with_index" do
    it "creates a Vector" do
      mapped = vector.map_with_index(&.itself)
      expect(mapped).to be_a(Geode::Vector1(Int32))
    end

    it "uses the new values" do
      mapped = vector.map_with_index { |v, i| v.to_f * i }
      expect(mapped).to eq(Geode::Vector1[0.0])
    end

    it "adds the offset" do
      mapped = vector.map_with_index(3) { |v, i| v * i }
      expect(mapped).to eq(Geode::Vector1[126])
    end
  end

  describe "#zip_map" do
    it "iterates two vectors" do
      v1 = Geode::Vector1[9]
      v2 = Geode::Vector1[2]
      result = v1.zip_map(v2) { |a, b| a // b }
      expect(result).to eq(Geode::Vector1[4])
    end
  end

  describe "#to_s" do
    subject { vector.to_s }

    it "is formatted correctly" do
      is_expected.to eq("(42)")
    end
  end

  describe "#to_slice" do
    it "is the size of the vector" do
      slice = vector.to_slice
      expect(slice.size).to eq(1)
    end

    it "contains the components" do
      slice = vector.to_slice
      expect(slice).to eq(Slice[42])
    end
  end

  describe "#to_unsafe" do
    it "references the components" do
      pointer = vector.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(42)
      end
    end
  end

  context Geode::VectorOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Vector1[-5].abs).to eq(Geode::Vector1[5])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Vector1[-5].abs2).to eq(Geode::Vector1[25])
      end
    end

    describe "#round" do
      it "rounds the components" do
        expect(Geode::Vector1[1.2].round).to eq(Geode::Vector1[1.0])
      end

      context "with digits" do
        it "rounds the components" do
          expect(Geode::Vector1[1.25].round(1)).to eq(Geode::Vector1[1.2])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each component" do
        expect(Geode::Vector1[-5].sign).to eq(Geode::Vector[-1])
      end
    end

    describe "#ceil" do
      it "returns the components rounded up" do
        expect(Geode::Vector1[1.2].ceil).to eq(Geode::Vector1[2.0])
      end
    end

    describe "#floor" do
      it "returns the components rounded down" do
        expect(Geode::Vector1[5.7].floor).to eq(Geode::Vector1[5.0])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each component" do
        fraction = Geode::Vector1[1.2].fraction
        expect(fraction.x).to be_within(TOLERANCE).of(0.2)
      end
    end

    describe "#clamp" do
      context "with a min and max vectors" do
        it "restricts components" do
          min = Geode::Vector1[-1]
          max = Geode::Vector1[1]
          expect(Geode::Vector1[-2].clamp(min, max)).to eq(Geode::Vector1[-1])
        end
      end

      context "with a range of vectors" do
        it "restricts components" do
          min = Geode::Vector1[-1]
          max = Geode::Vector1[1]
          expect(Geode::Vector1[2].clamp(min..max)).to eq(Geode::Vector1[1])
        end
      end

      context "with a min and max" do
        it "restricts components" do
          expect(Geode::Vector1[-2].clamp(-1, 1)).to eq(Geode::Vector1[-1])
        end
      end

      context "with a range" do
        it "restricts components" do
          expect(Geode::Vector1[2].clamp(-1..1)).to eq(Geode::Vector1[1])
        end
      end
    end

    describe "#edge" do
      context "with a scalar value" do
        it "returns correct zero and one components" do
          expect(vector.edge(20)).to eq(Geode::Vector1[1])
        end
      end

      context "with a vector" do
        it "returns correct zero and one components" do
          expect(vector.edge(Geode::Vector1[75])).to eq(Geode::Vector1[0])
        end
      end
    end

    describe "#scale" do
      context "with a vector" do
        let(other) { Geode::Vector1[3] }

        it "scales each component separately" do
          expect(vector.scale(other)).to eq(Geode::Vector1[126])
        end
      end

      context "with a scalar" do
        it "scales each component by the same amount" do
          expect(vector.scale(5)).to eq(Geode::Vector1[210])
        end
      end
    end

    describe "#scale!" do
      context "with a vector" do
        let(other) { Geode::Vector1[3] }

        it "scales each component separately" do
          expect(vector.scale!(other)).to eq(Geode::Vector[126])
        end
      end

      context "with a scalar" do
        it "scales each component by the same amount" do
          expect(vector.scale!(5)).to eq(Geode::Vector1[210])
        end
      end
    end

    describe "#lerp" do
      let(v1) { Geode::Vector1[3.0] }
      let(v2) { Geode::Vector1[23.0] }

      it "returns v1 when t = 0" do
        vector = v1.lerp(v2, 0.0)
        expect(vector.x).to be_within(TOLERANCE).of(3.0)
      end

      it "returns v2 when t = 1" do
        vector = v1.lerp(v2, 1.0)
        expect(vector.x).to be_within(TOLERANCE).of(23.0)
      end

      it "returns a mid-value" do
        vector = v1.lerp(v2, 0.4)
        expect(vector.x).to be_within(TOLERANCE).of(11.0)
      end
    end

    describe "#- (negation)" do
      it "negates the vector" do
        expect(-Geode::Vector1[3]).to eq(Geode::Vector1[-3])
      end
    end

    describe "#+" do
      it "adds two vectors" do
        v1 = Geode::Vector1[5]
        v2 = Geode::Vector1[2]
        expect(v1 + v2).to eq(Geode::Vector1[7])
      end
    end

    describe "#&+" do
      it "adds two vectors" do
        v1 = Geode::Vector1[5]
        v2 = Geode::Vector1[2]
        expect(v1 &+ v2).to eq(Geode::Vector1[7])
      end
    end

    describe "#-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector1[5]
        v2 = Geode::Vector1[2]
        expect(v1 - v2).to eq(Geode::Vector1[3])
      end
    end

    describe "#&-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector1[5]
        v2 = Geode::Vector1[2]
        expect(v1 &- v2).to eq(Geode::Vector1[3])
      end
    end

    describe "#*" do
      it "scales a vector" do
        expect(vector * 3).to eq(Geode::Vector1[126])
      end
    end

    describe "#&*" do
      it "scales a vector" do
        expect(vector &* 3).to eq(Geode::Vector1[126])
      end
    end

    describe "#/" do
      let(vector) { Geode::Vector1[6.0] }

      it "scales a vector" do
        expect(vector / 2).to eq(Geode::Vector1[3.0])
      end
    end

    describe "#//" do
      let(vector) { Geode::Vector1[6] }

      it "scales the vector" do
        expect(vector // 2).to eq(Geode::Vector1[3])
      end
    end
  end

  context Geode::VectorComparison do
    let(v1) { Geode::Vector1[0] }
    let(v2) { Geode::Vector1[1] }

    describe "#compare" do
      it "compares components" do
        expect(v1.compare(v2)).to eq(Geode::Vector1[-1])
      end
    end

    describe "#eq?" do
      it "compares components" do
        expect(v1.eq?(v2)).to eq(Geode::Vector1[false])
      end
    end

    describe "#lt?" do
      it "compares components" do
        expect(v1.lt?(v2)).to eq(Geode::Vector1[true])
      end
    end

    describe "#le?" do
      it "compares components" do
        expect(v1.le?(v2)).to eq(Geode::Vector1[true])
      end
    end

    describe "#gt?" do
      it "compares components" do
        expect(v1.gt?(v2)).to eq(Geode::Vector1[false])
      end
    end

    describe "#ge?" do
      it "compares components" do
        expect(v1.ge?(v2)).to eq(Geode::Vector1[false])
      end
    end

    describe "#zero?" do
      subject { vector.zero? }

      context "with a zero vector" do
        let(vector) { Geode::Vector1(Int32).zero }

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
        let(vector) { Geode::Vector1[0.01] }

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

    describe "#==" do
      subject { vector == other }
      let(other) { vector }

      context "with the same vector" do
        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a generic vector" do
        context "with equal values" do
          let(other) { Geode::Vector[42] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Vector[100] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different sized vector" do
          let(other) { Geode::Vector[1, 2, 3] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end

      context "with a n-dimension vector" do
        context "with equal values" do
          let(other) { Geode::Vector1[42] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Vector1[100] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different size" do
          let(other) { Geode::Vector3[1, 2, 3] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end
    end
  end

  context Geode::VectorGeometry do
    TOLERANCE = 0.000000001

    describe "#mag" do
      subject { vector.mag }

      it "returns the magnitude" do
        is_expected.to be_within(TOLERANCE).of(42.0)
      end
    end

    describe "#mag2" do
      subject { vector.mag2 }

      it "returns the magnitude squared" do
        is_expected.to eq(1764)
      end
    end

    describe "#length" do
      subject { vector.length }

      it "returns the magnitude" do
        is_expected.to be_within(TOLERANCE).of(42.0)
      end
    end

    describe "#normalize" do
      subject { vector.normalize }

      it "returns a unit vector" do
        expect(&.mag).to be_within(TOLERANCE).of(1.0)
      end

      it "scales the component" do
        expect(&.x).to be_within(TOLERANCE).of(1.0)
      end
    end

    describe "#scale_to" do
      subject { vector.scale_to(5.0) }

      it "returns a vector of the given magnitude" do
        expect(&.mag).to be_within(TOLERANCE).of(5.0)
      end

      it "scales the component" do
        expect(&.x).to be_within(TOLERANCE).of(5.0)
      end
    end

    describe "#dot" do
      subject { vector.dot(other) }
      let(other) { Geode::Vector1[5] }

      it "computes the dot-product" do
        is_expected.to eq(210)
      end
    end

    describe "#dot!" do
      subject { vector.dot!(other) }
      let(other) { Geode::Vector1[5] }

      it "computes the dot-product" do
        is_expected.to eq(210)
      end
    end

    describe "#project" do
      it "computes the projected vector" do
        proj = vector.project(Geode::Vector1[1])
        expect(proj.x).to be_within(TOLERANCE).of(42.0)
      end

      it "handles non-normalized vectors" do
        proj = vector.project(Geode::Vector1[3])
        expect(proj.x).to be_within(TOLERANCE).of(42.0)
      end
    end

    describe "#forward" do
      context "with a same-facing vector" do
        let(surface) { Geode::Vector1[5] }

        it "returns the same vector" do
          expect(vector.forward(surface)).to eq(vector)
        end
      end

      context "with an opposite-facing vector" do
        let(surface) { Geode::Vector1[-5] }

        it "returns a negated vector" do
          expect(vector.forward(surface)).to eq(-vector)
        end
      end
    end

    describe "#reflect" do
      it "computes a reflected vector" do
        incident = Geode::Vector1[-1]
        norm = Geode::Vector1[1]
        expect(incident.reflect(norm)).to eq(Geode::Vector1[1.0])
      end
    end

    describe "#refract" do
      it "computes a refracted vector" do
        incident = Geode::Vector1[-1]
        norm = Geode::Vector1[1]
        expect(incident.refract(norm, 1.5)).to eq(Geode::Vector1[-1.0])
      end
    end
  end
end
