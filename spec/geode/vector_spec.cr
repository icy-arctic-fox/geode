require "../spec_helper"

Spectator.describe Geode::Vector do
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
      aggregate_failures do
        expect(zero[0]).to eq(0)
        expect(zero[1]).to eq(0)
        expect(zero[2]).to eq(0)
      end
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
      aggregate_failures do
        expect(mapped[0]).to eq(2.0)
        expect(mapped[1]).to eq(4.0)
        expect(mapped[2]).to eq(6.0)
      end
    end
  end

  describe "#map_with_index" do
    it "creates a Vector" do
      mapped = vector.map_with_index(&.itself)
      expect(mapped).to be_a(Geode::Vector(Int32, 3))
    end

    it "uses the new values" do
      mapped = vector.map_with_index { |v, i| v * i }
      aggregate_failures do
        expect(mapped[0]).to eq(0)
        expect(mapped[1]).to eq(2)
        expect(mapped[2]).to eq(6)
      end
    end

    it "adds the offset" do
      mapped = vector.map_with_index(3) { |v, i| v * i }
      aggregate_failures do
        expect(mapped[0]).to eq(3)
        expect(mapped[1]).to eq(8)
        expect(mapped[2]).to eq(15)
      end
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
      aggregate_failures do
        expect(slice[0]).to eq(1)
        expect(slice[1]).to eq(2)
        expect(slice[2]).to eq(3)
      end
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
end
