require "./spec_helper"

Spectator.describe Geode do
  describe ".edge" do
    context "with a value smaller than the edge" do
      it "returns 0" do
        expect(Geode.edge(1, 3)).to eq(0)
      end
    end

    context "with a value larger than the edge" do
      it "returns 1" do
        expect(Geode.edge(5, 3)).to eq(1)
      end
    end
  end
end
