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
end
