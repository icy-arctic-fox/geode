require "../../spec_helper"

Spectator.describe Geode::Point1 do
  subject(point) { Geode::Point1.new(5) }

  it "stores the coordinates" do
    expect(point[0]).to eq(5)
  end

  describe "#initialize" do
    context "with a block" do
      it "yields the index" do
        args = [] of Int32
        Geode::Point1(Int32).new do |i|
          args << i
          42
        end
        expect(args).to eq([0])
      end

      it "use the block value" do
        point = Geode::Point1(Int32).new &.itself
        expect(point).to eq(Geode::Point1[0])
      end
    end

    context "with mismatched types" do
      it "converts the types" do
        point = Geode::Point1(Float64).new(1)
        expect(point[0]).to eq(1.0)
      end
    end
  end

  describe ".[]" do
    it "creates a point" do
      point = Geode::Point1[42]
      expect(point[0]).to eq(42)
    end

    it "casts types" do
      point = Geode::Point1(Float64)[2]
      expect(point[0]).to be(2.0)
    end
  end

  describe ".zero" do
    subject { Geode::Point1(Int32).zero }

    it "returns a point with all zeroes" do
      is_expected.to eq(Geode::Point1[0])
    end
  end

  describe ".origin" do
    subject { Geode::Point1(Int32).origin }

    it "returns a point with all zeroes" do
      is_expected.to eq(Geode::Point1[0])
    end
  end

  describe "#size" do
    subject { point.size }

    it "is 1" do
      is_expected.to eq(1)
    end
  end

  describe "#x" do
    subject { point.x }

    it "returns the x-coordinate" do
      is_expected.to eq(5)
    end
  end

  describe "#map" do
    it "transforms coordinates" do
      mapped = point.map { |v| v * 2.0 }
      expect(mapped).to eq(Geode::Point1[10.0])
    end
  end

  describe "#map_with_index" do
    it "transforms coordinates" do
      mapped = point.map_with_index { |v, _i| v * 2.0 }
      expect(mapped).to eq(Geode::Point1[10.0])
    end

    it "provides an offset" do
      mapped = point.map_with_index { |v, i| v * i }
      expect(mapped).to eq(Geode::Point1[0])
    end

    it "applies the offset" do
      mapped = point.map_with_index(2) { |v, i| v * i }
      expect(mapped).to eq(Geode::Point1[10])
    end
  end

  describe "#to_vector" do
    subject { point.to_vector }

    it "returns a vector" do
      is_expected.to eq(Geode::Vector1[5])
    end
  end

  describe "#tuple" do
    subject { point.tuple }

    it "returns a tuple" do
      is_expected.to eq({5})
    end
  end

  describe "to_row" do
    subject { point.to_row }

    it "returns a row vector" do
      is_expected.to eq(Geode::Matrix1x1[[5]])
    end
  end

  describe "to_column" do
    subject { point.to_column }

    it "returns a column vector" do
      is_expected.to eq(Geode::Matrix1x1[[5]])
    end
  end

  describe "#to_s" do
    subject { point.to_s }

    it "is formatted correctly" do
      is_expected.to eq("(5)")
    end
  end

  describe "#inspect" do
    subject { point.inspect }

    it "is formatted correctly" do
      is_expected.to eq("Geode::Point1(Int32)#<x: 5>")
    end
  end

  describe "#to_slice" do
    it "returns a slice containing the coordinates" do
      slice = point.to_slice
      expect(slice[0]).to eq(5)
    end

    it "has a size of 1" do
      slice = point.to_slice
      expect(slice.size).to eq(1)
    end
  end

  describe "#to_unsafe" do
    it "returns a pointer referencing the coordinates" do
      pointer = point.to_unsafe
      expect(pointer[0]).to eq(5)
    end
  end
end
