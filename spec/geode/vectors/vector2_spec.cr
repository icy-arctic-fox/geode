require "../../spec_helper"

Spectator.describe Geode::Vector2 do
  TOLERANCE = 0.000000000000001
  SQRT3     = Math.sqrt(3.0)

  subject(vector) { Geode::Vector2[1, 2] }

  describe ".[]" do
    it "stores values for components" do
      expect(vector).to have_attributes(x: 1, y: 2)
    end
  end

  describe ".new" do
    context "individual components" do
      it "stores values for components" do
        vector = described_class.new(1, 2)
        expect(vector).to have_attributes(x: 1, y: 2)
      end
    end

    context "Tuple" do
      it "stores values for components" do
        vector = described_class.new({1, 2})
        expect(vector).to have_attributes(x: 1, y: 2)
      end
    end

    context "StaticArray" do
      it "stores values for components" do
        array = StaticArray[1, 2]
        vector = described_class.new(array)
        expect(vector).to have_attributes(x: 1, y: 2)
      end
    end

    context "another vector" do
      it "stores values for components" do
        other = Geode::Vector[1, 2]
        vector = described_class.new(other)
        expect(vector).to have_attributes(x: 1, y: 2)
      end
    end

    context "block" do
      it "stores values for components" do
        vector = Geode::Vector2(Int32).new { |i| i + 1 }
        expect(vector).to have_attributes(x: 1, y: 2)
      end
    end
  end

  describe "#tuple" do
    subject { vector.tuple }

    it "returns a tuple containing the components" do
      is_expected.to eq({1, 2})
    end
  end

  describe "#angle" do
    it "computes the direction of the vector" do
      aggregate_failures do
        expect(Geode::Vector2[1.0, 0.0].angle).to be_within(TOLERANCE).of(0)
        expect(Geode::Vector2[SQRT3, 1.0].angle).to be_within(TOLERANCE).of(Math::PI / 6)
        expect(Geode::Vector2[0.0, 1.0].angle).to be_within(TOLERANCE).of(Math::PI / 2)
        expect(Geode::Vector2[-SQRT3, 1.0].angle).to be_within(TOLERANCE).of(Math::PI * 5 / 6)
        expect(Geode::Vector2[-1.0, 0.0].angle).to be_within(TOLERANCE).of(Math::PI)
        expect(Geode::Vector2[-1.0, -SQRT3].angle).to be_within(TOLERANCE).of(Math::PI * 4 / 3)
        expect(Geode::Vector2[0.0, -1.0].angle).to be_within(TOLERANCE).of(Math::PI * 3 / 2)
        expect(Geode::Vector2[1.0, -SQRT3].angle).to be_within(TOLERANCE).of(Math::PI * 5 / 3)
      end
    end
  end

  describe "#signed_angle" do
    it "computes the direction of the vector" do
      aggregate_failures do
        expect(Geode::Vector2[1.0, 0.0].signed_angle).to be_within(TOLERANCE).of(0)
        expect(Geode::Vector2[SQRT3, 1.0].signed_angle).to be_within(TOLERANCE).of(Math::PI / 6)
        expect(Geode::Vector2[0.0, 1.0].signed_angle).to be_within(TOLERANCE).of(Math::PI / 2)
        expect(Geode::Vector2[-SQRT3, 1.0].signed_angle).to be_within(TOLERANCE).of(Math::PI * 5 / 6)
        expect(Geode::Vector2[-1.0, 0.0].signed_angle).to be_within(TOLERANCE).of(Math::PI)
        expect(Geode::Vector2[-1.0, -SQRT3].signed_angle).to be_within(TOLERANCE).of(-Math::PI * 2 / 3)
        expect(Geode::Vector2[0.0, -1.0].signed_angle).to be_within(TOLERANCE).of(-Math::PI / 2)
        expect(Geode::Vector2[1.0, -SQRT3].signed_angle).to be_within(TOLERANCE).of(-Math::PI * 1 / 3)
      end
    end

    context "with another vector" do
      it "computes the angle between the vectors" do
        vector = Geode::Vector2[SQRT3, 1.0]
        aggregate_failures do
          expect(vector.signed_angle(Geode::Vector2[2 * SQRT3, 2.0])).to be_within(TOLERANCE).of(0)
          expect(vector.signed_angle(Geode::Vector2[-SQRT3, 1.0])).to be_within(TOLERANCE).of(Math::PI * 2 / 3)
          expect(vector.signed_angle(Geode::Vector2[-SQRT3, -1.0])).to be_within(TOLERANCE).of(Math::PI)
          expect(vector.signed_angle(Geode::Vector2[0.0, -1.0])).to be_within(TOLERANCE).of(-Math::PI * 2 / 3)
          expect(vector.signed_angle(Geode::Vector2[SQRT3, -1.0])).to be_within(TOLERANCE).of(-Math::PI / 3)
        end
      end
    end
  end

  describe "#rotate" do
    it "rotates the vector" do
      vector = Geode::Vector2[3.0, 4.0]
      rotated = vector.rotate(270.degrees)
      aggregate_failures do
        expect(rotated.x).to be_within(TOLERANCE).of(4)
        expect(rotated.y).to be_within(TOLERANCE).of(-3)
      end
    end

    it "rotates negative amounts" do
      vector = Geode::Vector2[3.0, 4.0]
      rotated = vector.rotate(-90.degrees)
      aggregate_failures do
        expect(rotated.x).to be_within(TOLERANCE).of(4)
        expect(rotated.y).to be_within(TOLERANCE).of(-3)
      end
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

    it "is formatted correctly" do
      is_expected.to eq("(1, 2)")
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
          expect(fraction.x).to be_within(TOLERANCE).of(0.2)
          expect(fraction.y).to be_within(TOLERANCE).of(0.3)
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

    describe "#scale!" do
      context "with a vector" do
        let(other) { Geode::Vector2[2, 3] }

        it "scales each component separately" do
          expect(vector.scale!(other)).to eq(Geode::Vector2[2, 6])
        end
      end

      context "with a scalar" do
        it "scales each component by the same amount" do
          expect(vector.scale!(5)).to eq(Geode::Vector2[5, 10])
        end
      end
    end

    describe "#lerp" do
      let(v1) { Geode::Vector2[3.0, 5.0] }
      let(v2) { Geode::Vector2[23.0, 35.0] }

      it "returns v1 when t = 0" do
        vector = v1.lerp(v2, 0.0)
        aggregate_failures do
          expect(vector.x).to be_within(TOLERANCE).of(3.0)
          expect(vector.y).to be_within(TOLERANCE).of(5.0)
        end
      end

      it "returns v2 when t = 1" do
        vector = v1.lerp(v2, 1.0)
        aggregate_failures do
          expect(vector.x).to be_within(TOLERANCE).of(23.0)
          expect(vector.y).to be_within(TOLERANCE).of(35.0)
        end
      end

      it "returns a mid-value" do
        vector = v1.lerp(v2, 0.4)
        aggregate_failures do
          expect(vector.x).to be_within(TOLERANCE).of(11.0)
          expect(vector.y).to be_within(TOLERANCE).of(17.0)
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

    describe "#&+" do
      it "adds two vectors" do
        v1 = Geode::Vector2[5, -2]
        v2 = Geode::Vector2[2, -1]
        expect(v1 &+ v2).to eq(Geode::Vector2[7, -3])
      end
    end

    describe "#-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector2[5, -2]
        v2 = Geode::Vector2[2, -1]
        expect(v1 - v2).to eq(Geode::Vector2[3, -1])
      end
    end

    describe "#&-" do
      it "subtracts two vectors" do
        v1 = Geode::Vector2[5, -2]
        v2 = Geode::Vector2[2, -1]
        expect(v1 &- v2).to eq(Geode::Vector2[3, -1])
      end
    end

    describe "#*" do
      it "scales a vector" do
        expect(vector * 3).to eq(Geode::Vector2[3, 6])
      end
    end

    describe "#&*" do
      it "scales a vector" do
        expect(vector &* 3).to eq(Geode::Vector2[3, 6])
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
          let(other) { Geode::Vector[1, 2] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Vector[3, 2] }

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
          let(other) { Geode::Vector2[1, 2] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Vector2[2, 1] }

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
          expect(vector.x / subject.x).to be_within(TOLERANCE).of(scale)
          expect(vector.y / subject.y).to be_within(TOLERANCE).of(scale)
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
          expect(vector.x / subject.x).to be_within(TOLERANCE).of(scale)
          expect(vector.y / subject.y).to be_within(TOLERANCE).of(scale)
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

    describe "#dot!" do
      subject { vector.dot!(other) }
      let(other) { Geode::Vector2[10, 20] }

      it "computes the dot-product" do
        is_expected.to eq(50)
      end
    end

    describe "#angle" do
      it "computes the angle between vectors" do
        vector = Geode::Vector2[SQRT3, 1.0]
        aggregate_failures do
          expect(vector.angle(Geode::Vector2[2 * SQRT3, 2.0])).to be_within(TOLERANCE).of(0)
          expect(vector.angle(Geode::Vector2[-SQRT3, 1.0])).to be_within(TOLERANCE).of(Math::PI * 2 / 3)
          expect(vector.angle(Geode::Vector2[-SQRT3, -1.0])).to be_within(TOLERANCE).of(Math::PI)
          expect(vector.angle(Geode::Vector2[0.0, -1.0])).to be_within(TOLERANCE).of(Math::PI * 2 / 3)
          expect(vector.angle(Geode::Vector2[SQRT3, -1.0])).to be_within(TOLERANCE).of(Math::PI / 3)
        end
      end
    end

    describe "#project" do
      it "computes the projected vector" do
        proj = vector.project(Geode::Vector2[1, 1].normalize)
        aggregate_failures do
          expect(proj.x).to be_within(TOLERANCE).of(1.5)
          expect(proj.y).to be_within(TOLERANCE).of(1.5)
        end
      end

      it "handles non-normalized vectors" do
        proj = vector.project(Geode::Vector2[3, 4])
        aggregate_failures do
          expect(proj.x).to be_within(TOLERANCE).of(1.32)
          expect(proj.y).to be_within(TOLERANCE).of(1.76)
        end
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

  context Geode::VectorMatrices do
    describe "#to_row" do
      subject { vector.to_row }

      it "returns a row vector" do
        is_expected.to eq(Geode::Matrix[[1, 2]])
      end
    end

    describe "#to_column" do
      subject { vector.to_column }

      it "returns a column vector" do
        is_expected.to eq(Geode::Matrix[[1], [2]])
      end
    end

    describe "#*(matrix)" do
      let(matrix) { Geode::Matrix[[1, 10], [2, 20]] }
      subject { vector * matrix }

      it "multiplies the vector and matrix" do
        is_expected.to eq(Geode::Vector[5, 50])
      end
    end

    describe "#&*(matrix)" do
      let(matrix) { Geode::Matrix[[1, 10], [2, 20]] }
      subject { vector &* matrix }

      it "multiplies the vector and matrix" do
        is_expected.to eq(Geode::Vector[5, 50])
      end
    end
  end
end
