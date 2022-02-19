require "../../spec_helper"

Spectator.describe Geode::Point3 do
  subject(point) { Geode::Point3.new(5, 7, 9) }

  it "stores the coordinates" do
    aggregate_failures do
      expect(point[0]).to eq(5)
      expect(point[1]).to eq(7)
      expect(point[2]).to eq(9)
    end
  end

  describe "#initialize" do
    context "with a block" do
      it "yields the index" do
        args = [] of Int32
        Geode::Point3(Int32).new do |i|
          args << i
          42
        end
        expect(args).to eq([0, 1, 2])
      end

      it "use the block value" do
        point = Geode::Point3(Int32).new &.itself
        expect(point).to eq(Geode::Point3[0, 1, 2])
      end
    end

    context "with mismatched types" do
      it "converts the types" do
        point = Geode::Point3(Float64).new(1, 2, 3)
        aggregate_failures do
          expect(point[0]).to eq(1.0)
          expect(point[1]).to eq(2.0)
          expect(point[2]).to eq(3.0)
        end
      end
    end
  end

  describe ".[]" do
    it "creates a point" do
      point = Geode::Point3[42, 24, 21]
      aggregate_failures do
        expect(point[0]).to eq(42)
        expect(point[1]).to eq(24)
        expect(point[2]).to eq(21)
      end
    end

    it "casts types" do
      point = Geode::Point3(Float64)[2, 4, 6]
      aggregate_failures do
        expect(point[0]).to be(2.0)
        expect(point[1]).to be(4.0)
        expect(point[2]).to be(6.0)
      end
    end
  end

  describe ".zero" do
    subject { Geode::Point3(Int32).zero }

    it "returns a point with all zeroes" do
      is_expected.to eq(Geode::Point3[0, 0, 0])
    end
  end

  describe ".origin" do
    subject { Geode::Point3(Int32).origin }

    it "returns a point with all zeroes" do
      is_expected.to eq(Geode::Point3[0, 0, 0])
    end
  end

  describe "#size" do
    subject { point.size }

    it "is 3" do
      is_expected.to eq(3)
    end
  end

  describe "#x" do
    subject { point.x }

    it "returns the x-coordinate" do
      is_expected.to eq(5)
    end
  end

  describe "#y" do
    subject { point.y }

    it "returns the y-coordinate" do
      is_expected.to eq(7)
    end
  end

  describe "#z" do
    subject { point.z }

    it "returns the z-coordinate" do
      is_expected.to eq(9)
    end
  end

  describe "#map" do
    it "transforms coordinates" do
      mapped = point.map { |v| v * 2.0 }
      expect(mapped).to eq(Geode::Point3[10.0, 14.0, 18.0])
    end
  end

  describe "#map_with_index" do
    it "transforms coordinates" do
      mapped = point.map_with_index { |v, _i| v * 2.0 }
      expect(mapped).to eq(Geode::Point3[10.0, 14.0, 18.0])
    end

    it "provides an offset" do
      mapped = point.map_with_index { |v, i| v * i }
      expect(mapped).to eq(Geode::Point3[0, 7, 18])
    end

    it "applies the offset" do
      mapped = point.map_with_index(2) { |v, i| v * i }
      expect(mapped).to eq(Geode::Point3[10, 21, 36])
    end
  end

  describe "#zero?" do
    subject { point.zero? }

    context "with an origin point" do
      let(point) { Geode::Point3(Int32).origin }

      it "is true" do
        is_expected.to be_true
      end
    end

    context "with a non-origin point" do
      it "is false" do
        is_expected.to be_false
      end
    end
  end

  describe "#near_zero?" do
    let(tolerance) { 0.001 }
    subject { point.near_zero?(tolerance) }

    context "with an origin point" do
      let(point) { Geode::Point3(Float64).origin }

      it "is true" do
        is_expected.to be_true
      end
    end

    context "with a point within tolerance" do
      let(point) { Geode::Point3(Float64).new(0.0001, -0.0002, 0.0003) }

      it "is true" do
        is_expected.to be_true
      end
    end

    context "with a non-origin point" do
      it "is false" do
        is_expected.to be_false
      end
    end
  end

  describe "#to_vector" do
    subject { point.to_vector }

    it "returns a vector" do
      is_expected.to eq(Geode::Vector3[5, 7, 9])
    end
  end

  describe "#tuple" do
    subject { point.tuple }

    it "returns a tuple" do
      is_expected.to eq({5, 7, 9})
    end
  end

  describe "to_row" do
    subject { point.to_row }

    it "returns a row vector" do
      is_expected.to eq(Geode::Matrix1x3[[5, 7, 9]])
    end
  end

  describe "to_column" do
    subject { point.to_column }

    it "returns a column vector" do
      is_expected.to eq(Geode::Matrix3x1[[5], [7], [9]])
    end
  end

  describe "#to_s" do
    subject { point.to_s }

    it "is formatted correctly" do
      is_expected.to eq("(5, 7, 9)")
    end
  end

  describe "#inspect" do
    subject { point.inspect }

    it "is formatted correctly" do
      is_expected.to eq("Geode::Point3(Int32)#<x: 5, y: 7, z: 9>")
    end
  end

  describe "#to_slice" do
    it "returns a slice containing the coordinates" do
      slice = point.to_slice
      aggregate_failures do
        expect(slice[0]).to eq(5)
        expect(slice[1]).to eq(7)
        expect(slice[2]).to eq(9)
      end
    end

    it "has a size of 3" do
      slice = point.to_slice
      expect(slice.size).to eq(3)
    end
  end

  describe "#to_unsafe" do
    it "returns a pointer referencing the coordinates" do
      pointer = point.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(5)
        expect(pointer[1]).to eq(7)
        expect(pointer[2]).to eq(9)
      end
    end
  end

  describe "#==" do
    subject { point == other }

    context "with the same point" do
      let(other) { point }

      it "returns true" do
        is_expected.to be_true
      end
    end

    context "with different coordinate type" do
      context "and equal values" do
        let(other) { Geode::Point3(Float32).new(5.0, 7.0, 9.0) }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "and different values" do
        let(other) { Geode::Point3(Float32).new(1.0, 2.0, 3.0) }

        it "returns false" do
          is_expected.to be_false
        end
      end
    end

    context "with a different size" do
      let(other) { Geode::Point2(Int32).origin }

      it "return false" do
        is_expected.to be_false
      end
    end
  end
end
