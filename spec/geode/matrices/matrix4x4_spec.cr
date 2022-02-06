require "../../spec_helper"

Spectator.describe Geode::Matrix4x4 do
  include Tolerance

  TOLERANCE = 0.000000000000001

  subject(matrix) { Geode::Matrix4x4[[4, 3, 4, 3], [2, 1, 2, 1], [8, 7, 8, 7], [6, 5, 6, 5]] }

  it "stores values for elements" do
    aggregate_failures do
      expect(matrix[0, 0]).to eq(4)
      expect(matrix[0, 1]).to eq(3)
      expect(matrix[0, 2]).to eq(4)
      expect(matrix[0, 3]).to eq(3)
      expect(matrix[1, 0]).to eq(2)
      expect(matrix[1, 1]).to eq(1)
      expect(matrix[1, 2]).to eq(2)
      expect(matrix[1, 3]).to eq(1)
      expect(matrix[2, 0]).to eq(8)
      expect(matrix[2, 1]).to eq(7)
      expect(matrix[2, 2]).to eq(8)
      expect(matrix[2, 3]).to eq(7)
      expect(matrix[3, 0]).to eq(6)
      expect(matrix[3, 1]).to eq(5)
      expect(matrix[3, 2]).to eq(6)
      expect(matrix[3, 3]).to eq(5)
    end
  end

  describe "#initialize" do
    it "accepts a flat list of elements" do
      matrix = Geode::Matrix4x4.new({4, 3, 4, 3, 2, 1, 2, 1, 8, 7, 8, 7, 6, 5, 6, 5})
      aggregate_failures do
        expect(matrix[0, 0]).to eq(4)
        expect(matrix[0, 1]).to eq(3)
        expect(matrix[0, 2]).to eq(4)
        expect(matrix[0, 3]).to eq(3)
        expect(matrix[1, 0]).to eq(2)
        expect(matrix[1, 1]).to eq(1)
        expect(matrix[1, 2]).to eq(2)
        expect(matrix[1, 3]).to eq(1)
        expect(matrix[2, 0]).to eq(8)
        expect(matrix[2, 1]).to eq(7)
        expect(matrix[2, 2]).to eq(8)
        expect(matrix[2, 3]).to eq(7)
        expect(matrix[3, 0]).to eq(6)
        expect(matrix[3, 1]).to eq(5)
        expect(matrix[3, 2]).to eq(6)
        expect(matrix[3, 3]).to eq(5)
      end
    end

    it "accepts a list of rows" do
      matrix = Geode::Matrix4x4.new({ {4, 3, 4, 3}, {2, 1, 2, 1}, {8, 7, 8, 7}, {6, 5, 6, 5} })
      aggregate_failures do
        expect(matrix[0, 0]).to eq(4)
        expect(matrix[0, 1]).to eq(3)
        expect(matrix[0, 2]).to eq(4)
        expect(matrix[0, 3]).to eq(3)
        expect(matrix[1, 0]).to eq(2)
        expect(matrix[1, 1]).to eq(1)
        expect(matrix[1, 2]).to eq(2)
        expect(matrix[1, 3]).to eq(1)
        expect(matrix[2, 0]).to eq(8)
        expect(matrix[2, 1]).to eq(7)
        expect(matrix[2, 2]).to eq(8)
        expect(matrix[2, 3]).to eq(7)
        expect(matrix[3, 0]).to eq(6)
        expect(matrix[3, 1]).to eq(5)
        expect(matrix[3, 2]).to eq(6)
        expect(matrix[3, 3]).to eq(5)
      end
    end

    it "accepts another matrix" do
      other = Geode::Matrix[[4, 3, 4, 3], [2, 1, 2, 1], [8, 7, 8, 7], [6, 5, 6, 5]]
      matrix = Geode::Matrix4x4.new(other)
      aggregate_failures do
        expect(matrix[0, 0]).to eq(4)
        expect(matrix[0, 1]).to eq(3)
        expect(matrix[0, 2]).to eq(4)
        expect(matrix[0, 3]).to eq(3)
        expect(matrix[1, 0]).to eq(2)
        expect(matrix[1, 1]).to eq(1)
        expect(matrix[1, 2]).to eq(2)
        expect(matrix[1, 3]).to eq(1)
        expect(matrix[2, 0]).to eq(8)
        expect(matrix[2, 1]).to eq(7)
        expect(matrix[2, 2]).to eq(8)
        expect(matrix[2, 3]).to eq(7)
        expect(matrix[3, 0]).to eq(6)
        expect(matrix[3, 1]).to eq(5)
        expect(matrix[3, 2]).to eq(6)
        expect(matrix[3, 3]).to eq(5)
      end
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Matrix4x4(Int32).zero }

    it "returns a zero matrix" do
      expect(zero).to eq(Geode::Matrix4x4[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
    end
  end

  describe ".identity" do
    subject(identity) { Geode::Matrix4x4(Int32).identity }

    it "returns an identity matrix" do
      expect(identity).to eq(Geode::Matrix4x4[[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
    end
  end

  describe ".new(scalar)" do
    subject(square) { Geode::Matrix4x4(Int32).new(7) }

    it "returns a matrix with the diagonal filled" do
      expect(square).to eq(Geode::Matrix4x4[[7, 0, 0, 0], [0, 7, 0, 0], [0, 0, 7, 0], [0, 0, 0, 7]])
    end
  end

  describe "#map" do
    it "creates a matrix" do
      mapped = matrix.map(&.itself)
      expect(mapped).to be_a(Geode::Matrix4x4(Int32))
    end

    it "uses the new values" do
      mapped = matrix.map { |e| e.to_f * 2 }
      expect(mapped).to eq(Geode::Matrix4x4[[8.0, 6.0, 8.0, 6.0], [4.0, 2.0, 4.0, 2.0], [16.0, 14.0, 16.0, 14.0], [12.0, 10.0, 12.0, 10.0]])
    end
  end

  describe "#transpose" do
    subject { matrix.transpose }

    it "transposes the matrix" do
      is_expected.to eq(Geode::Matrix4x4[[4, 2, 8, 6], [3, 1, 7, 5], [4, 2, 8, 6], [3, 1, 7, 5]])
    end
  end

  describe "#sub" do
    let(matrix) { Geode::Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]] }
    subject { matrix.sub(1, 1) }

    it "produces a sub-matrix" do
      is_expected.to eq(Geode::Matrix[[1, 3, 4], [9, 11, 12], [13, 15, 16]])
    end
  end

  describe "#*(matrix)" do
    let(m1) { Geode::Matrix4x4[[3, 5, 7, 9], [2, 4, 6, 8], [7, 5, 3, 1], [6, 4, 2, 0]] }
    subject { m1 * m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2], [3, 4], [5, 6], [7, 8]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[116, 140], [100, 120], [44, 60], [28, 40]])
      end
    end

    context "with a 4x1 matrix" do
      let(m2) { Geode::Matrix4x1[[1], [2], [3], [4]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70], [60], [30], [20]])
      end
    end

    context "with a 4x2 matrix" do
      let(m2) { Geode::Matrix4x2[[1, 10], [2, 20], [3, 30], [4, 40]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700], [60, 600], [30, 300], [20, 200]])
      end
    end

    context "with a 4x3 matrix" do
      let(m2) { Geode::Matrix4x3[[1, 10, 100], [2, 20, 200], [3, 30, 300], [4, 40, 400]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700, 7000], [60, 600, 6000], [30, 300, 3000], [20, 200, 2000]])
      end
    end

    context "with a 4x4 matrix" do
      let(m2) { Geode::Matrix4x4[[1, 10, 100, 1000], [2, 20, 200, 2000], [3, 30, 300, 3000], [4, 40, 400, 4000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700, 7000, 70000], [60, 600, 6000, 60000], [30, 300, 3000, 30000], [20, 200, 2000, 20000]])
      end
    end
  end

  describe "#&*(matrix)" do
    let(m1) { Geode::Matrix4x4[[3, 5, 7, 9], [2, 4, 6, 8], [7, 5, 3, 1], [6, 4, 2, 0]] }
    subject { m1 &* m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2], [3, 4], [5, 6], [7, 8]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[116, 140], [100, 120], [44, 60], [28, 40]])
      end
    end

    context "with a 4x1 matrix" do
      let(m2) { Geode::Matrix4x1[[1], [2], [3], [4]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70], [60], [30], [20]])
      end
    end

    context "with a 4x2 matrix" do
      let(m2) { Geode::Matrix4x2[[1, 10], [2, 20], [3, 30], [4, 40]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700], [60, 600], [30, 300], [20, 200]])
      end
    end

    context "with a 4x3 matrix" do
      let(m2) { Geode::Matrix4x3[[1, 10, 100], [2, 20, 200], [3, 30, 300], [4, 40, 400]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700, 7000], [60, 600, 6000], [30, 300, 3000], [20, 200, 2000]])
      end
    end

    context "with a 4x4 matrix" do
      let(m2) { Geode::Matrix4x4[[1, 10, 100, 1000], [2, 20, 200, 2000], [3, 30, 300, 3000], [4, 40, 400, 4000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[70, 700, 7000, 70000], [60, 600, 6000, 60000], [30, 300, 3000, 30000], [20, 200, 2000, 20000]])
      end
    end
  end

  describe "#to_slice" do
    it "is the size of the matrix" do
      slice = matrix.to_slice
      expect(slice.size).to eq(16)
    end

    it "contains the elements" do
      slice = matrix.to_slice
      expect(slice).to eq(Slice[4, 3, 4, 3, 2, 1, 2, 1, 8, 7, 8, 7, 6, 5, 6, 5])
    end
  end

  describe "#to_unsafe" do
    it "references the elements" do
      pointer = matrix.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(4)
        expect(pointer[1]).to eq(3)
        expect(pointer[2]).to eq(4)
        expect(pointer[3]).to eq(3)
        expect(pointer[4]).to eq(2)
        expect(pointer[5]).to eq(1)
        expect(pointer[6]).to eq(2)
        expect(pointer[7]).to eq(1)
        expect(pointer[8]).to eq(8)
        expect(pointer[9]).to eq(7)
        expect(pointer[10]).to eq(8)
        expect(pointer[11]).to eq(7)
        expect(pointer[12]).to eq(6)
        expect(pointer[13]).to eq(5)
        expect(pointer[14]).to eq(6)
        expect(pointer[15]).to eq(5)
      end
    end
  end

  describe "#a" do
    subject { matrix.a }

    it "returns element (0, 0)" do
      is_expected.to eq(matrix[0, 0])
    end
  end

  describe "#b" do
    subject { matrix.b }

    it "returns element (0, 1)" do
      is_expected.to eq(matrix[0, 1])
    end
  end

  describe "#c" do
    subject { matrix.c }

    it "returns element (0, 2)" do
      is_expected.to eq(matrix[0, 2])
    end
  end

  describe "#d" do
    subject { matrix.d }

    it "returns element (0, 3)" do
      is_expected.to eq(matrix[0, 3])
    end
  end

  describe "#e" do
    subject { matrix.e }

    it "returns element (1, 0)" do
      is_expected.to eq(matrix[1, 0])
    end
  end

  describe "#f" do
    subject { matrix.f }

    it "returns element (1, 1)" do
      is_expected.to eq(matrix[1, 1])
    end
  end

  describe "#g" do
    subject { matrix.g }

    it "returns element (1, 2)" do
      is_expected.to eq(matrix[1, 2])
    end
  end

  describe "#h" do
    subject { matrix.h }

    it "returns element (1, 3)" do
      is_expected.to eq(matrix[1, 3])
    end
  end

  describe "#i" do
    subject { matrix.i }

    it "returns element (2, 0)" do
      is_expected.to eq(matrix[2, 0])
    end
  end

  describe "#j" do
    subject { matrix.j }

    it "returns element (2, 1)" do
      is_expected.to eq(matrix[2, 1])
    end
  end

  describe "#k" do
    subject { matrix.k }

    it "returns element (2, 2)" do
      is_expected.to eq(matrix[2, 2])
    end
  end

  describe "#l" do
    subject { matrix.l }

    it "returns element (2, 3)" do
      is_expected.to eq(matrix[2, 3])
    end
  end

  describe "#m" do
    subject { matrix.m }

    it "returns element (3, 0)" do
      is_expected.to eq(matrix[3, 0])
    end
  end

  describe "#n" do
    subject { matrix.n }

    it "returns element (3, 1)" do
      is_expected.to eq(matrix[3, 1])
    end
  end

  describe "#o" do
    subject { matrix.o }

    it "returns element (3, 2)" do
      is_expected.to eq(matrix[3, 2])
    end
  end

  describe "#p" do
    subject { matrix.p }

    it "returns element (3, 3)" do
      is_expected.to eq(matrix[3, 3])
    end
  end

  context Geode::CommonMatrix do
    describe "#rows" do
      subject { matrix.rows }

      it "is the correct value" do
        is_expected.to eq(4)
      end
    end

    describe "#columns" do
      subject { matrix.columns }

      it "is the correct value" do
        is_expected.to eq(4)
      end
    end

    describe "#size" do
      subject { matrix.size }

      it "is the correct value" do
        is_expected.to eq(16)
      end
    end

    describe "#square?" do
      subject { matrix.square? }

      it "is true" do
        is_expected.to be_true
      end
    end

    describe "#each_indices" do
      it "yields each combination of indices" do
        indices = [] of Tuple(Int32, Int32)
        matrix.each_indices do |i, j|
          indices << {i, j}
        end
        expect(indices).to eq([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}, {2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 0}, {3, 1}, {3, 2}, {3, 3}])
      end
    end

    describe "#each_with_indices" do
      it "yields each element with its indices" do
        indices = [] of Tuple(Int32, Int32, Int32)
        matrix.each_with_indices do |e, i, j|
          indices << {e, i, j}
        end
        expect(indices).to eq([{4, 0, 0}, {3, 0, 1}, {4, 0, 2}, {3, 0, 3}, {2, 1, 0}, {1, 1, 1}, {2, 1, 2}, {1, 1, 3}, {8, 2, 0}, {7, 2, 1}, {8, 2, 2}, {7, 2, 3}, {6, 3, 0}, {5, 3, 1}, {6, 3, 2}, {5, 3, 3}])
      end
    end

    describe "#map_with_index" do
      it "creates a Matrix4x4" do
        mapped = matrix.map_with_index(&.itself)
        expect(mapped).to be_a(Geode::Matrix4x4(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_index { |e, i| e.to_f * i }
        expect(mapped).to eq(Geode::Matrix4x4[[0.0, 3.0, 8.0, 9.0], [8.0, 5.0, 12.0, 7.0], [64.0, 63.0, 80.0, 77.0], [72.0, 65.0, 84.0, 75.0]])
      end

      it "adds the offset" do
        mapped = matrix.map_with_index(3) { |e, i| e * i }
        expect(mapped).to eq(Geode::Matrix4x4[[12, 12, 20, 18], [14, 8, 18, 10], [88, 84, 104, 98], [90, 80, 102, 90]])
      end
    end

    describe "#map_with_indices" do
      it "creates a Matrix4x4" do
        mapped = matrix.map_with_indices(&.itself)
        expect(mapped).to be_a(Geode::Matrix4x4(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_indices { |e, i, j| e.to_f * i + j }
        expect(mapped).to eq(Geode::Matrix4x4[[0.0, 1.0, 2.0, 3.0], [2.0, 2.0, 4.0, 4.0], [16.0, 15.0, 18.0, 17.0], [18.0, 16.0, 20.0, 18.0]])
      end
    end

    describe "#zip_map" do
      it "iterates two matrices" do
        m1 = Geode::Matrix4x4[[6, 1, 6, 1], [0, 7, 0, 7], [4, 8, 4, 8], [9, 5, 9, 5]]
        m2 = Geode::Matrix4x4[[3, 1, 3, 1], [2, 2, 2, 2], [4, 2, 4, 2], [3, 1, 3, 1]]
        result = m1.zip_map(m2) { |a, b| a // b }
        expect(result).to eq(Geode::Matrix4x4[[2, 1, 2, 1], [0, 3, 0, 3], [1, 4, 1, 4], [3, 5, 3, 5]])
      end
    end

    describe "#each_row" do
      it "enumerates each row" do
        rows = [] of Geode::CommonVector(Int32, 4)
        matrix.each_row { |row| rows << row }
        expect(rows).to eq([Geode::Vector[4, 3, 4, 3], Geode::Vector[2, 1, 2, 1], Geode::Vector[8, 7, 8, 7], Geode::Vector[6, 5, 6, 5]])
      end
    end

    describe "#each_row_with_index" do
      it "enumerates each row" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 4), Int32)
        matrix.each_row_with_index { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[4, 3, 4, 3], 0}, {Geode::Vector[2, 1, 2, 1], 1}, {Geode::Vector[8, 7, 8, 7], 2}, {Geode::Vector[6, 5, 6, 5], 3}])
      end

      it "applies the offset" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 4), Int32)
        matrix.each_row_with_index(5) { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[4, 3, 4, 3], 5}, {Geode::Vector[2, 1, 2, 1], 6}, {Geode::Vector[8, 7, 8, 7], 7}, {Geode::Vector[6, 5, 6, 5], 8}])
      end
    end

    describe "#each_column" do
      it "enumerates each column" do
        columns = [] of Geode::CommonVector(Int32, 4)
        matrix.each_column { |column| columns << column }
        expect(columns).to eq([Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5], Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5]])
      end
    end

    describe "#each_column_with_index" do
      it "enumerates each column" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 4), Int32)
        matrix.each_column_with_index { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[4, 2, 8, 6], 0}, {Geode::Vector[3, 1, 7, 5], 1}, {Geode::Vector[4, 2, 8, 6], 2}, {Geode::Vector[3, 1, 7, 5], 3}])
      end

      it "applies the offset" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 4), Int32)
        matrix.each_column_with_index(3) { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[4, 2, 8, 6], 3}, {Geode::Vector[3, 1, 7, 5], 4}, {Geode::Vector[4, 2, 8, 6], 5}, {Geode::Vector[3, 1, 7, 5], 6}])
      end
    end

    describe "#[]" do
      context "with a flat index" do
        it "returns the correct element" do
          expect(matrix[1]).to eq(3)
        end

        it "raises for an out-of-bound index" do
          expect { matrix[20] }.to raise_error(IndexError)
        end
      end

      context "with two indices" do
        it "returns the correct value" do
          expect(matrix[1, 1]).to eq(1)
        end

        it "raises for out-of-bound indices" do
          expect { matrix[4, 4] }.to raise_error(IndexError)
        end
      end
    end

    describe "#[]?" do
      context "with a flat index" do
        it "returns the correct element" do
          expect(matrix[1]?).to eq(3)
        end

        it "returns nil for an out-of-bound index" do
          expect(matrix[20]?).to be_nil
        end
      end

      context "with two indices" do
        it "returns the correct value" do
          expect(matrix[1, 1]?).to eq(1)
        end

        it "returns nil for out-of-bound indices" do
          expect(matrix[4, 4]?).to be_nil
        end
      end
    end

    describe "#row" do
      it "returns the correct elements" do
        expect(matrix.row(1)).to eq(Geode::Vector[2, 1, 2, 1])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.row(5) }.to raise_error(IndexError)
      end
    end

    describe "#row?" do
      it "returns the correct elements" do
        expect(matrix.row?(1)).to eq(Geode::Vector[2, 1, 2, 1])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.row?(5)).to be_nil
      end
    end

    describe "#column" do
      it "returns the correct elements" do
        expect(matrix.column(1)).to eq(Geode::Vector[3, 1, 7, 5])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.column(5) }.to raise_error(IndexError)
      end
    end

    describe "#column?" do
      it "returns the correct elements" do
        expect(matrix.column?(1)).to eq(Geode::Vector[3, 1, 7, 5])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.column?(5)).to be_nil
      end
    end

    describe "#rows_at" do
      it "returns the correct rows" do
        expect(matrix.rows_at(1, 3)).to eq({Geode::Vector[2, 1, 2, 1], Geode::Vector[6, 5, 6, 5]})
      end
    end

    describe "#columns_at" do
      it "returns the correct columns" do
        expect(matrix.columns_at(0, 1)).to eq({Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5]})
      end
    end

    describe "#to_rows" do
      subject { matrix.to_rows }

      it "returns row vectors in an array" do
        is_expected.to eq([Geode::Vector[4, 3, 4, 3], Geode::Vector[2, 1, 2, 1], Geode::Vector[8, 7, 8, 7], Geode::Vector[6, 5, 6, 5]])
      end
    end

    describe "#to_columns" do
      subject { matrix.to_columns }

      it "returns column vectors in an array" do
        is_expected.to eq([Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5], Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5]])
      end
    end

    describe "#to_s" do
      subject { matrix.to_s }

      it "is formatted correctly" do
        is_expected.to eq("[[4, 3, 4, 3], [2, 1, 2, 1], [8, 7, 8, 7], [6, 5, 6, 5]]")
      end
    end
  end

  context Geode::MatrixComparison do
    let(m1) { Geode::Matrix[[4, 3, 4, 3], [2, 1, 2, 1], [0, 1, 0, 1], [1, 0, 1, 0]] }
    let(m2) { Geode::Matrix[[1, 2, 1, 2], [3, 4, 3, 4], [1, 0, 1, 0], [1, 0, 1, 0]] }

    describe "#compare" do
      it "compares elements" do
        expect(m1.compare(m2)).to eq(Geode::Matrix[[1, 1, 1, 1], [-1, -1, -1, -1], [-1, 1, -1, 1], [0, 0, 0, 0]])
      end
    end

    describe "#eq?" do
      it "compares elements" do
        expect(m1.eq?(m2)).to eq(Geode::Matrix[[false, false, false, false], [false, false, false, false], [false, false, false, false], [true, true, true, true]])
      end
    end

    describe "#lt?" do
      it "compares elements" do
        expect(m1.lt?(m2)).to eq(Geode::Matrix[[false, false, false, false], [true, true, true, true], [true, false, true, false], [false, false, false, false]])
      end
    end

    describe "#le?" do
      it "compares elements" do
        expect(m1.le?(m2)).to eq(Geode::Matrix[[false, false, false, false], [true, true, true, true], [true, false, true, false], [true, true, true, true]])
      end
    end

    describe "#gt?" do
      it "compares elements" do
        expect(m1.gt?(m2)).to eq(Geode::Matrix[[true, true, true, true], [false, false, false, false], [false, true, false, true], [false, false, false, false]])
      end
    end

    describe "#ge?" do
      it "compares elements" do
        expect(m1.ge?(m2)).to eq(Geode::Matrix[[true, true, true, true], [false, false, false, false], [false, true, false, true], [true, true, true, true]])
      end
    end

    describe "#zero?" do
      subject { matrix.zero? }

      context "with a zero matrix" do
        let(matrix) { Geode::Matrix4x4(Int32).zero }

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
      subject { matrix.near_zero?(0.1) }

      context "with elements within tolerance of zero" do
        let(matrix) { Geode::Matrix4x4[[0.05, 0.0, 0.05, 0.0], [0.01, 0.025, 0.01, 0.025], [0.1, -0.02, 0.1, -0.02], [-0.1, -0.025, -0.1, -0.025]] }

        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with elements not within tolerance of zero" do
        it "returns false" do
          is_expected.to be_false
        end
      end
    end

    describe "#==" do
      subject { matrix == other }
      let(other) { matrix }

      context "with the same matrix" do
        it "returns true" do
          is_expected.to be_true
        end
      end

      context "with a generic matrix" do
        context "with equal values" do
          let(other) { Geode::Matrix[[4, 3, 4, 3], [2, 1, 2, 1], [8, 7, 8, 7], [6, 5, 6, 5]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix[[5, 6, 5, 6], [7, 8, 7, 8], [1, 2, 1, 2], [3, 4, 3, 4]] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different sized matrix" do
          let(other) { Geode::Matrix[[4, 3, 2, 1], [8, 7, 6, 5]] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end

      context "with a nxm-dimension matrix" do
        context "with equal values" do
          let(other) { Geode::Matrix4x4[[4, 3, 4, 3], [2, 1, 2, 1], [8, 7, 8, 7], [6, 5, 6, 5]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix4x4[[5, 6, 5, 6], [7, 8, 7, 8], [1, 2, 1, 2], [3, 4, 3, 4]] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different size" do
          let(other) { Geode::Matrix3[[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end
    end
  end

  context Geode::MatrixIterators do
    describe "#each_indices" do
      subject { matrix.each_indices }

      it "iterates through each pair of indices" do
        expect(subject.to_a).to eq([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}, {2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 0}, {3, 1}, {3, 2}, {3, 3}])
      end
    end

    describe "#each_with_indices" do
      subject { matrix.each_with_indices }

      it "iterates through each element and its indices" do
        expect(subject.to_a).to eq([{4, 0, 0}, {3, 0, 1}, {4, 0, 2}, {3, 0, 3}, {2, 1, 0}, {1, 1, 1}, {2, 1, 2}, {1, 1, 3}, {8, 2, 0}, {7, 2, 1}, {8, 2, 2}, {7, 2, 3}, {6, 3, 0}, {5, 3, 1}, {6, 3, 2}, {5, 3, 3}])
      end
    end

    describe "#each_row" do
      subject { matrix.each_row }

      it "iterates through each row" do
        expect(subject.to_a).to eq([Geode::Vector[4, 3, 4, 3], Geode::Vector[2, 1, 2, 1], Geode::Vector[8, 7, 8, 7], Geode::Vector[6, 5, 6, 5]])
      end
    end

    describe "#each_row_with_index" do
      subject { matrix.each_row_with_index }

      it "iterates through each row" do
        expect(subject.to_a).to eq([{Geode::Vector[4, 3, 4, 3], 0}, {Geode::Vector[2, 1, 2, 1], 1}, {Geode::Vector[8, 7, 8, 7], 2}, {Geode::Vector[6, 5, 6, 5], 3}])
      end

      context "with an offset" do
        subject { matrix.each_row_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[4, 3, 4, 3], 3}, {Geode::Vector[2, 1, 2, 1], 4}, {Geode::Vector[8, 7, 8, 7], 5}, {Geode::Vector[6, 5, 6, 5], 6}])
        end
      end
    end

    describe "#each_column" do
      subject { matrix.each_column }

      it "iterates through each column" do
        expect(subject.to_a).to eq([Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5], Geode::Vector[4, 2, 8, 6], Geode::Vector[3, 1, 7, 5]])
      end
    end

    describe "#each_column_with_index" do
      subject { matrix.each_column_with_index }

      it "iterates through each column" do
        expect(subject.to_a).to eq([{Geode::Vector[4, 2, 8, 6], 0}, {Geode::Vector[3, 1, 7, 5], 1}, {Geode::Vector[4, 2, 8, 6], 2}, {Geode::Vector[3, 1, 7, 5], 3}])
      end

      context "with an offset" do
        subject { matrix.each_column_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[4, 2, 8, 6], 3}, {Geode::Vector[3, 1, 7, 5], 4}, {Geode::Vector[4, 2, 8, 6], 5}, {Geode::Vector[3, 1, 7, 5], 6}])
        end
      end
    end
  end

  context Geode::MatrixOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Matrix4x4[[2, -1, 2, -1], [0, -2, 0, -2], [-5, 4, -5, 4], [-3, 0, -3, 0]].abs).to eq(Geode::Matrix4x4[[2, 1, 2, 1], [0, 2, 0, 2], [5, 4, 5, 4], [3, 0, 3, 0]])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Matrix4x4[[2, -1, 2, -1], [0, -2, 0, -2], [-5, 4, -5, 4], [-3, 0, -3, 0]].abs2).to eq(Geode::Matrix4x4[[4, 1, 4, 1], [0, 4, 0, 4], [25, 16, 25, 16], [9, 0, 9, 0]])
      end
    end

    describe "#round" do
      it "rounds the elements" do
        expect(Geode::Matrix4x4[[1.2, 3.0, 1.2, 3.0], [0.0, 1.7, 0.0, 1.7], [-5.7, 1.5, -5.7, 1.5], [1.0, 2.3, 1.0, 2.3]].round).to eq(Geode::Matrix4x4[[1.0, 3.0, 1.0, 3.0], [0.0, 2.0, 0.0, 2.0], [-6.0, 2.0, -6.0, 2.0], [1.0, 2.0, 1.0, 2.0]])
      end

      context "with digits" do
        it "rounds the elements" do
          expect(Geode::Matrix4x4[[1.25, 3.01, 1.25, 3.01], [0.0, 1.73, 0.0, 1.73], [-5.77, 1.5, -5.77, 1.5], [1.0, -2.37, 1.0, -2.37]].round(1)).to eq(Geode::Matrix4x4[[1.2, 3.0, 1.2, 3.0], [0.0, 1.7, 0.0, 1.7], [-5.8, 1.5, -5.8, 1.5], [1.0, -2.4, 1.0, -2.4]])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each element" do
        expect(Geode::Matrix4x4[[2, -1, 2, -1], [0, -2, 0, -2], [-5, 4, -5, 4], [-3, 0, -3, 0]].sign).to eq(Geode::Matrix4x4[[1, -1, 1, -1], [0, -1, 0, -1], [-1, 1, -1, 1], [-1, 0, -1, 0]])
      end
    end

    describe "#ceil" do
      it "returns the elements rounded up" do
        expect(Geode::Matrix4x4[[1.2, 3.0, 1.2, 3.0], [0.0, 1.7, 0.0, 1.7], [-5.7, 1.5, -5.7, 1.5], [1.0, 2.3, 1.0, 2.3]].ceil).to eq(Geode::Matrix4x4[[2.0, 3.0, 2.0, 3.0], [0.0, 2.0, 0.0, 2.0], [-5.0, 2.0, -5.0, 2.0], [1.0, 3.0, 1.0, 3.0]])
      end
    end

    describe "#floor" do
      it "returns the elements rounded down" do
        expect(Geode::Matrix4x4[[1.2, 3.0, 1.2, 3.0], [0.0, 1.7, 0.0, 1.7], [-5.7, 1.5, -5.7, 1.5], [1.0, 2.3, 1.0, 2.3]].floor).to eq(Geode::Matrix4x4[[1.0, 3.0, 1.0, 3.0], [0.0, 1.0, 0.0, 1.0], [-6.0, 1.0, -6.0, 1.0], [1.0, 2.0, 1.0, 2.0]])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each element" do
        fraction = Geode::Matrix4x4[[1.2, 3.0, 1.2, 3.0], [0.0, 1.7, 0.0, 1.7], [-5.7, 1.5, -5.7, 1.5], [1.0, 2.4, 1.0, 2.4]].fraction
        aggregate_failures do
          expect(fraction[0, 0]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[0, 1]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[0, 2]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[0, 3]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[1, 0]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[1, 1]).to be_within(TOLERANCE).of(0.7)
          expect(fraction[1, 2]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[1, 3]).to be_within(TOLERANCE).of(0.7)
          expect(fraction[2, 0]).to be_within(TOLERANCE).of(0.3)
          expect(fraction[2, 1]).to be_within(TOLERANCE).of(0.5)
          expect(fraction[2, 2]).to be_within(TOLERANCE).of(0.3)
          expect(fraction[2, 3]).to be_within(TOLERANCE).of(0.5)
          expect(fraction[3, 0]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[3, 1]).to be_within(TOLERANCE).of(0.4)
          expect(fraction[3, 2]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[3, 3]).to be_within(TOLERANCE).of(0.4)
        end
      end
    end

    describe "#clamp" do
      context "with a min and max matrices" do
        it "restricts elements" do
          min = Geode::Matrix4x4[[-1, -2, -1, -2], [-3, -4, -3, -4], [-5, -6, -5, -6], [-7, -8, -7, -8]]
          max = Geode::Matrix4x4[[1, 2, 1, 2], [3, 4, 3, 4], [5, 6, 5, 6], [7, 8, 7, 8]]
          expect(Geode::Matrix4x4[[-2, 0, -2, 0], [4, -7, 4, -7], [3, 1, 3, 1], [-9, 9, -9, 9]].clamp(min, max)).to eq(Geode::Matrix4x4[[-1, 0, -1, 0], [3, -4, 3, -4], [3, 1, 3, 1], [-7, 8, -7, 8]])
        end
      end

      context "with a range of matrices" do
        it "restricts elements" do
          min = Geode::Matrix4x4[[-1, -2, -1, -2], [-3, -4, -3, -4], [-5, -6, -5, -6], [-7, -8, -7, -8]]
          max = Geode::Matrix4x4[[1, 2, 1, 2], [3, 4, 3, 4], [5, 6, 5, 6], [7, 8, 7, 8]]
          expect(Geode::Matrix4x4[[-2, 0, -2, 0], [4, -7, 4, -7], [3, 1, 3, 1], [-9, 9, -9, 9]].clamp(min, max)).to eq(Geode::Matrix4x4[[-1, 0, -1, 0], [3, -4, 3, -4], [3, 1, 3, 1], [-7, 8, -7, 8]])
        end
      end

      context "with a min and max" do
        it "restricts elements" do
          expect(Geode::Matrix4x4[[-2, 0, -2, 0], [4, -7, 4, -7], [2, 1, 2, 1], [-9, 9, -9, 9]].clamp(-1, 1)).to eq(Geode::Matrix4x4[[-1, 0, -1, 0], [1, -1, 1, -1], [1, 1, 1, 1], [-1, 1, -1, 1]])
        end
      end

      context "with a range" do
        it "restricts elements" do
          expect(Geode::Matrix4x4[[-2, 0, -2, 0], [4, -7, 4, -7], [2, 1, 2, 1], [-1, 9, -1, 9]].clamp(-1..1)).to eq(Geode::Matrix4x4[[-1, 0, -1, 0], [1, -1, 1, -1], [1, 1, 1, 1], [-1, 1, -1, 1]])
        end
      end
    end

    describe "#edge" do
      context "with a scalar value" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(4)).to eq(Geode::Matrix4x4[[1, 0, 1, 0], [0, 0, 0, 0], [1, 1, 1, 1], [1, 1, 1, 1]])
        end
      end

      context "with a matrix" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(Geode::Matrix4x4[[2, 3, 2, 3], [1, 4, 1, 4], [9, 0, 9, 0], [-1, -7, -1, -7]])).to eq(Geode::Matrix4x4[[1, 1, 1, 1], [1, 0, 1, 0], [0, 1, 0, 1], [1, 1, 1, 1]])
        end
      end
    end

    describe "#scale" do
      context "with a matrix" do
        let(other) { Geode::Matrix4x4[[2, 3, 2, 3], [4, 5, 4, 5], [6, 7, 6, 7], [8, 9, 8, 9]] }

        it "scales each element separately" do
          expect(matrix.scale(other)).to eq(Geode::Matrix4x4[[8, 9, 8, 9], [8, 5, 8, 5], [48, 49, 48, 49], [48, 45, 48, 45]])
        end
      end
    end

    describe "#scale!" do
      context "with a matrix" do
        let(other) { Geode::Matrix4x4[[2, 3, 2, 3], [4, 5, 4, 5], [6, 7, 6, 7], [8, 9, 8, 9]] }

        it "scales each element separately" do
          expect(matrix.scale!(other)).to eq(Geode::Matrix4x4[[8, 9, 8, 9], [8, 5, 8, 5], [48, 49, 48, 49], [48, 45, 48, 45]])
        end
      end
    end

    describe "#lerp" do
      let(m1) { Geode::Matrix4x4[[1.0, 2.0, 1.0, 2.0], [3.0, 4.0, 3.0, 4.0], [5.0, 6.0, 5.0, 6.0], [7.0, 8.0, 7.0, 8.0]] }
      let(m2) { Geode::Matrix4x4[[11.0, 22.0, 11.0, 22.0], [33.0, 44.0, 33.0, 44.0], [55.0, 66.0, 55.0, 66.0], [77.0, 88.0, 77.0, 88.0]] }

      it "returns m1 when t = 0" do
        matrix = m1.lerp(m2, 0.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(1.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(2.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(1.0)
          expect(matrix[0, 3]).to be_within(TOLERANCE).of(2.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(3.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(4.0)
          expect(matrix[1, 2]).to be_within(TOLERANCE).of(3.0)
          expect(matrix[1, 3]).to be_within(TOLERANCE).of(4.0)
          expect(matrix[2, 0]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[2, 1]).to be_within(TOLERANCE).of(6.0)
          expect(matrix[2, 2]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[2, 3]).to be_within(TOLERANCE).of(6.0)
          expect(matrix[3, 0]).to be_within(TOLERANCE).of(7.0)
          expect(matrix[3, 1]).to be_within(TOLERANCE).of(8.0)
          expect(matrix[3, 2]).to be_within(TOLERANCE).of(7.0)
          expect(matrix[3, 3]).to be_within(TOLERANCE).of(8.0)
        end
      end

      it "returns m2 when t = 1" do
        matrix = m1.lerp(m2, 1.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(11.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(22.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(11.0)
          expect(matrix[0, 3]).to be_within(TOLERANCE).of(22.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(33.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(44.0)
          expect(matrix[1, 2]).to be_within(TOLERANCE).of(33.0)
          expect(matrix[1, 3]).to be_within(TOLERANCE).of(44.0)
          expect(matrix[2, 0]).to be_within(TOLERANCE).of(55.0)
          expect(matrix[2, 1]).to be_within(TOLERANCE).of(66.0)
          expect(matrix[2, 2]).to be_within(TOLERANCE).of(55.0)
          expect(matrix[2, 3]).to be_within(TOLERANCE).of(66.0)
          expect(matrix[3, 0]).to be_within(TOLERANCE).of(77.0)
          expect(matrix[3, 1]).to be_within(TOLERANCE).of(88.0)
          expect(matrix[3, 2]).to be_within(TOLERANCE).of(77.0)
          expect(matrix[3, 3]).to be_within(TOLERANCE).of(88.0)
        end
      end

      it "returns a mid-value" do
        matrix = m1.lerp(m2, 0.4)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(10.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[0, 3]).to be_within(TOLERANCE).of(10.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(15.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(20.0)
          expect(matrix[1, 2]).to be_within(TOLERANCE).of(15.0)
          expect(matrix[1, 3]).to be_within(TOLERANCE).of(20.0)
          expect(matrix[2, 0]).to be_within(TOLERANCE).of(25.0)
          expect(matrix[2, 1]).to be_within(TOLERANCE).of(30.0)
          expect(matrix[2, 2]).to be_within(TOLERANCE).of(25.0)
          expect(matrix[2, 3]).to be_within(TOLERANCE).of(30.0)
          expect(matrix[3, 0]).to be_within(TOLERANCE).of(35.0)
          expect(matrix[3, 1]).to be_within(TOLERANCE).of(40.0)
          expect(matrix[3, 2]).to be_within(TOLERANCE).of(35.0)
          expect(matrix[3, 3]).to be_within(TOLERANCE).of(40.0)
        end
      end
    end

    describe "#- (negation)" do
      it "negates the matrix" do
        expect(-Geode::Matrix4x4[[3, 1, 3, 1], [2, -5, 2, -5], [-3, 0, -3, 0], [-1, 5, -1, 5]]).to eq(Geode::Matrix4x4[[-3, -1, -3, -1], [-2, 5, -2, 5], [3, 0, 3, 0], [1, -5, 1, -5]])
      end
    end

    describe "#+" do
      it "adds two matrices" do
        m1 = Geode::Matrix4x4[[5, 1, 5, 1], [3, 1, 3, 1], [7, 2, 7, 2], [0, -3, 0, -3]]
        m2 = Geode::Matrix4x4[[2, 0, 2, 0], [2, 1, 2, 1], [4, 3, 4, 3], [2, 3, 2, 3]]
        expect(m1 + m2).to eq(Geode::Matrix4x4[[7, 1, 7, 1], [5, 2, 5, 2], [11, 5, 11, 5], [2, 0, 2, 0]])
      end
    end

    describe "#&+" do
      it "adds two matrices" do
        m1 = Geode::Matrix4x4[[5, 1, 5, 1], [3, 1, 3, 1], [7, 2, 7, 2], [0, -3, 0, -3]]
        m2 = Geode::Matrix4x4[[2, 0, 2, 0], [2, 1, 2, 1], [4, 3, 4, 3], [2, 3, 2, 3]]
        expect(m1 &+ m2).to eq(Geode::Matrix4x4[[7, 1, 7, 1], [5, 2, 5, 2], [11, 5, 11, 5], [2, 0, 2, 0]])
      end
    end

    describe "#-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix4x4[[5, 1, 5, 1], [0, 1, 0, 1], [7, 8, 7, 8], [-1, -3, -1, -3]]
        m2 = Geode::Matrix4x4[[2, 0, 2, 0], [2, 1, 2, 1], [5, 4, 5, 4], [2, -3, 2, -3]]
        expect(m1 - m2).to eq(Geode::Matrix4x4[[3, 1, 3, 1], [-2, 0, -2, 0], [2, 4, 2, 4], [-3, 0, -3, 0]])
      end
    end

    describe "#&-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix4x4[[5, 1, 5, 1], [0, 1, 0, 1], [7, 8, 7, 8], [-1, -3, -1, -3]]
        m2 = Geode::Matrix4x4[[2, 0, 2, 0], [2, 1, 2, 1], [5, 4, 5, 4], [2, -3, 2, -3]]
        expect(m1 &- m2).to eq(Geode::Matrix4x4[[3, 1, 3, 1], [-2, 0, -2, 0], [2, 4, 2, 4], [-3, 0, -3, 0]])
      end
    end

    describe "#*(number)" do
      it "scales a matrix" do
        expect(matrix * 3).to eq(Geode::Matrix4x4[[12, 9, 12, 9], [6, 3, 6, 3], [24, 21, 24, 21], [18, 15, 18, 15]])
      end
    end

    describe "#&*(number)" do
      it "scales a matrix" do
        expect(matrix &* 3).to eq(Geode::Matrix4x4[[12, 9, 12, 9], [6, 3, 6, 3], [24, 21, 24, 21], [18, 15, 18, 15]])
      end
    end

    describe "#/" do
      it "scales a matrix" do
        matrix = Geode::Matrix4x4[[8.0, 4.0, 8.0, 4.0], [2.0, 1.0, 2.0, 1.0], [6.0, 0.0, 6.0, 0.0], [9.0, -5.0, 9.0, -5.0]]
        expect(matrix / 2).to eq(Geode::Matrix4x4[[4.0, 2.0, 4.0, 2.0], [1.0, 0.5, 1.0, 0.5], [3.0, 0.0, 3.0, 0.0], [4.5, -2.5, 4.5, -2.5]])
      end
    end

    describe "#//" do
      it "scales the matrix" do
        matrix = Geode::Matrix4x4[[4, 2, 4, 2], [3, -1, 3, -1], [6, 1, 6, 1], [0, -5, 0, -5]]
        expect(matrix // 2).to eq(Geode::Matrix4x4[[2, 1, 2, 1], [1, -1, 1, -1], [3, 0, 3, 0], [0, -3, 0, -3]])
      end
    end
  end

  context Geode::MatrixVectors do
    describe "#row?" do
      subject { matrix.row? }

      it "is false" do
        is_expected.to be_false
      end
    end

    describe "#column?" do
      subject { matrix.column? }

      it "is false" do
        is_expected.to be_false
      end
    end

    describe "#*(vector)" do
      let(vector) { Geode::Vector[10, 20, 30, 40] }
      subject { matrix * vector }

      it "multiplies the matrix and vector" do
        is_expected.to eq(Geode::Vector[340, 140, 740, 540])
      end
    end

    describe "#&*(vector)" do
      let(vector) { Geode::Vector[10, 20, 30, 40] }
      subject { matrix &* vector }

      it "multiplies the matrix and vector" do
        is_expected.to eq(Geode::Vector[340, 140, 740, 540])
      end
    end
  end

  context Geode::SquareMatrix do
    describe "#diagonal" do
      subject { matrix.diagonal }

      it "returns the diagonal elements" do
        is_expected.to eq(Geode::Vector[4, 1, 8, 5])
      end
    end

    describe "#each_diagonal (block)" do
      it "iterates over the diagonal" do
        elements = [] of Int32
        matrix.each_diagonal { |e| elements << e }
        expect(elements).to eq([4, 1, 8, 5])
      end
    end

    describe "#each_diagonal (iterator)" do
      subject { matrix.each_diagonal }

      it "iterates over the diagonal" do
        expect(subject.to_a).to eq([4, 1, 8, 5])
      end
    end

    describe "#trace" do
      subject { matrix.trace }

      it "is the sum of the diagonal" do
        is_expected.to eq(18)
      end
    end

    describe "#determinant" do
      let(matrix) { Geode::Matrix4x4[[9, 3, 6, -1], [5, 1, 8, -2], [2, 7, 4, -3], [-4, -5, -6, -7]] }
      subject { matrix.determinant }

      it "computes the determinant" do
        is_expected.to eq(2730)
      end
    end

    describe "#inverse" do
      TOLERANCE = 0.000000001

      subject { matrix.inverse }

      context "with an invertible matrix" do
        let(matrix) { Geode::Matrix4x4[[4, 7, 3, 5], [2, 6, 5, 8], [1, 0, 9, 2], [7, 5, 3, 1]] }

        xit "returns an inverted matrix" do
          expect_within_tolerance(subject.not_nil!,
            -0.568093385, 0.338521401, -0.128404669, 0.389105058,
            0.795719844, -0.484435798, 0.114785992, -0.332684825,
            0.190661479, -0.147859922, 0.159533074, -0.089494163,
            -0.573929961, 0.496108949, -0.153696498, 0.208171206)
        end
      end

      context "with a non-invertible matrix" do
        let(matrix) { Geode::Matrix4x4[[2, 3, 4, 5], [4, 6, 8, 10], [6, 9, 12, 15], [8, 12, 16, 20]] }

        xit "returns nil" do
          is_expected.to be_nil
        end
      end
    end
  end

  context Geode::Matrix4x4Transforms3DConstructors do
    let(vector) { Geode::Vector4[1, 1, 1, 1] }
    let(transformed) { vector * matrix }

    context "3D transforms" do
      SQRT2 = Math.sqrt(2)

      describe ".rotate" do
        let(axis) { Geode::Vector3[1, 2, 3].normalize }
        let(matrix) { Geode::Matrix4(Float64).rotate(45.degrees, axis) }

        it "rotates the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(0.6436502098876993)
            expect(transformed.y).to be_within(TOLERANCE).of(1.3361225846073057)
            expect(transformed.z).to be_within(TOLERANCE).of(0.89470154029923)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".rotate_x" do
        let(matrix) { Geode::Matrix4(Float64).rotate_x(45.degrees) }

        it "rotates the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(1)
            expect(transformed.y).to be_within(TOLERANCE).of(0)
            expect(transformed.z).to be_within(TOLERANCE).of(SQRT2)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".rotate_y" do
        let(matrix) { Geode::Matrix4(Float64).rotate_y(45.degrees) }

        it "rotates the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(SQRT2)
            expect(transformed.y).to be_within(TOLERANCE).of(1)
            expect(transformed.z).to be_within(TOLERANCE).of(0)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".rotate_z" do
        let(matrix) { Geode::Matrix4(Float64).rotate_z(45.degrees) }

        it "rotates the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(0)
            expect(transformed.y).to be_within(TOLERANCE).of(SQRT2)
            expect(transformed.z).to be_within(TOLERANCE).of(1)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".scale(amount)" do
        let(matrix) { Geode::Matrix4(Float64).scale(3) }

        it "scales the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(3)
            expect(transformed.y).to be_within(TOLERANCE).of(3)
            expect(transformed.z).to be_within(TOLERANCE).of(3)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".scale(x, y, z)" do
        let(matrix) { Geode::Matrix4(Float64).scale(3, 4, 5) }

        it "scales the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(3)
            expect(transformed.y).to be_within(TOLERANCE).of(4)
            expect(transformed.z).to be_within(TOLERANCE).of(5)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".reflect_x" do
        let(matrix) { Geode::Matrix4(Float64).reflect_x }

        it "reflects the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(-1)
            expect(transformed.y).to be_within(TOLERANCE).of(1)
            expect(transformed.z).to be_within(TOLERANCE).of(1)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".reflect_y" do
        let(matrix) { Geode::Matrix4(Float64).reflect_y }

        it "reflects the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(1)
            expect(transformed.y).to be_within(TOLERANCE).of(-1)
            expect(transformed.z).to be_within(TOLERANCE).of(1)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".reflect_z" do
        let(matrix) { Geode::Matrix4(Float64).reflect_z }

        it "reflects the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(1)
            expect(transformed.y).to be_within(TOLERANCE).of(1)
            expect(transformed.z).to be_within(TOLERANCE).of(-1)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".shear_x" do
        let(matrix) { Geode::Matrix4(Float64).shear_x(2, 3) }

        it "shears the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(1)
            expect(transformed.y).to be_within(TOLERANCE).of(3)
            expect(transformed.z).to be_within(TOLERANCE).of(4)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".shear_y" do
        let(matrix) { Geode::Matrix4(Float64).shear_y(2, 3) }

        it "shears the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(3)
            expect(transformed.y).to be_within(TOLERANCE).of(1)
            expect(transformed.z).to be_within(TOLERANCE).of(4)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".shear_z" do
        let(matrix) { Geode::Matrix4(Float64).shear_z(2, 3) }

        it "shears the vector" do
          aggregate_failures do
            expect(transformed.x).to be_within(TOLERANCE).of(3)
            expect(transformed.y).to be_within(TOLERANCE).of(4)
            expect(transformed.z).to be_within(TOLERANCE).of(1)
            expect(transformed.w).to eq(1)
          end
        end
      end

      describe ".translate" do
        let(matrix) { Geode::Matrix4(Int32).translate(2, 3, 4) }

        it "translates the vector" do
          aggregate_failures do
            expect(transformed.x).to eq(3)
            expect(transformed.y).to eq(4)
            expect(transformed.z).to eq(5)
            expect(transformed.w).to eq(1)
          end
        end
      end
    end
  end

  context Geode::Matrix4x4Transforms3D do
    TOLERANCE = 0.000000001
    SQRT8     = Math.sqrt(8)

    let(vector) { Geode::Vector4[1, 1, 1, 1] }
    let(original) { Geode::Matrix4[[2, 0, 0, 0], [0, 2, 0, 0], [0, 0, 2, 0], [0, 0, 0, 1]] }
    let(transformed) { vector * matrix }

    describe "#rotate" do
      let(axis) { Geode::Vector3[1, 2, 3].normalize }
      let(matrix) { original.rotate(135.degrees, axis) }

      it "rotates the vector" do
        aggregate_failures do
          expect(transformed.x).to be_within(TOLERANCE).of(-0.328943652)
          expect(transformed.y).to be_within(TOLERANCE).of(2.268184151)
          expect(transformed.z).to be_within(TOLERANCE).of(2.597525116)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#rotate_x" do
      let(matrix) { original.rotate_x(135.degrees) }

      it "rotates the vector" do
        aggregate_failures do
          expect(transformed.x).to be_within(TOLERANCE).of(2)
          expect(transformed.y).to be_within(TOLERANCE).of(-SQRT8)
          expect(transformed.z).to be_within(TOLERANCE).of(0)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#rotate_y" do
      let(matrix) { original.rotate_y(135.degrees) }

      it "rotates the vector" do
        aggregate_failures do
          expect(transformed.x).to be_within(TOLERANCE).of(0)
          expect(transformed.y).to be_within(TOLERANCE).of(2)
          expect(transformed.z).to be_within(TOLERANCE).of(-SQRT8)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#rotate_z" do
      let(matrix) { original.rotate_z(135.degrees) }

      it "rotates the vector" do
        aggregate_failures do
          expect(transformed.x).to be_within(TOLERANCE).of(-SQRT8)
          expect(transformed.y).to be_within(TOLERANCE).of(0)
          expect(transformed.z).to be_within(TOLERANCE).of(2)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#scale3(amount)" do
      let(matrix) { original.scale3(3) }

      it "scales the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(6)
          expect(transformed.y).to eq(6)
          expect(transformed.z).to eq(6)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#scale(x, y, z)" do
      let(matrix) { original.scale(3, 4, 5) }

      it "scales the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(6)
          expect(transformed.y).to eq(8)
          expect(transformed.z).to eq(10)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#reflect_x" do
      let(matrix) { original.reflect_x }

      it "reflects the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(-2)
          expect(transformed.y).to eq(2)
          expect(transformed.z).to eq(2)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#reflect_y" do
      let(matrix) { original.reflect_y }

      it "reflects the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(2)
          expect(transformed.y).to eq(-2)
          expect(transformed.z).to eq(2)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#reflect_z" do
      let(matrix) { original.reflect_z }

      it "reflects the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(2)
          expect(transformed.y).to eq(2)
          expect(transformed.z).to eq(-2)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#shear_x" do
      let(matrix) { original.shear_x(2, 3) }

      it "shears the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(2)
          expect(transformed.y).to eq(6)
          expect(transformed.z).to eq(8)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#shear_y" do
      let(matrix) { original.shear_y(2, 3) }

      it "shears the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(6)
          expect(transformed.y).to eq(2)
          expect(transformed.z).to eq(8)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#shear_z" do
      let(matrix) { original.shear_z(2, 3) }

      it "shears the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(6)
          expect(transformed.y).to eq(8)
          expect(transformed.z).to eq(2)
          expect(transformed.w).to eq(1)
        end
      end
    end

    describe "#translate" do
      let(matrix) { original.translate(2, 3, 4) }

      it "translates the vector" do
        aggregate_failures do
          expect(transformed.x).to eq(4)
          expect(transformed.y).to eq(5)
          expect(transformed.z).to eq(6)
          expect(transformed.w).to eq(1)
        end
      end
    end
  end

  context Geode::MatrixProjections do
    TOLERANCE = 0.000000001

    describe ".ortho (2D)" do
      let(matrix) { Geode::Matrix4x4(Float64).ortho(-400.0, 400.0, -300.0, 300.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / 400, 0, 0, 0,
          0, 1 / 300, 0, 0,
          0, 0, -1, 0,
          0, 0, 0, 1)
      end
    end

    describe ".ortho (3D)" do
      let(args) { {-400.0, 400.0, -300.0, 300.0, 1.0, 100.0} }
      subject { Geode::Matrix4x4(Float64).ortho(*args) }

      it "uses the method matching the compiler flags" do
        {% if flag?(:left_handed) %}
          {% if flag?(:z_zero_one) %}
            lh_zo = Geode::Matrix4x4(Float64).ortho_lh_zo(*args)
            is_expected.to eq(lh_zo)
          {% else %}
            lh_no = Geode::Matrix4x4(Float64).ortho_lh_no(*args)
            is_expected.to eq(lh_no)
          {% end %}
        {% else %}
          {% if flag?(:z_zero_one) %}
            rh_zo = Geode::Matrix4x4(Float64).ortho_rh_zo(*args)
            is_expected.to eq(rh_zo)
          {% else %}
            rh_no = Geode::Matrix4x4(Float64).ortho_rh_no(*args)
            is_expected.to eq(rh_no)
          {% end %}
        {% end %}
      end
    end

    describe ".ortho_rh_no" do
      let(matrix) { Geode::Matrix4x4(Float64).ortho_rh_no(-400.0, 400.0, -300.0, 300.0, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / 400, 0, 0, 0,
          0, 1 / 300, 0, 0,
          0, 0, -2 / 99, 0,
          0, 0, -101 / 99, 1)
      end
    end

    describe ".ortho_rh_zo" do
      let(matrix) { Geode::Matrix4x4(Float64).ortho_rh_zo(-400.0, 400.0, -300.0, 300.0, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / 400, 0, 0, 0,
          0, 1 / 300, 0, 0,
          0, 0, -1 / 99, 0,
          0, 0, -1 / 99, 1)
      end
    end

    describe ".ortho_lh_no" do
      let(matrix) { Geode::Matrix4x4(Float64).ortho_lh_no(-400.0, 400.0, -300.0, 300.0, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / 400, 0, 0, 0,
          0, 1 / 300, 0, 0,
          0, 0, 2 / 99, 0,
          0, 0, -101 / 99, 1)
      end
    end

    describe ".ortho_lh_zo" do
      let(matrix) { Geode::Matrix4x4(Float64).ortho_lh_zo(-400.0, 400.0, -300.0, 300.0, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / 400, 0, 0, 0,
          0, 1 / 300, 0, 0,
          0, 0, 1 / 99, 0,
          0, 0, -1 / 99, 1)
      end
    end

    describe ".perspective" do
      let(args) { {Geode::Degrees.new(45.0), 800 / 600, 1.0, 100.0} }
      subject { Geode::Matrix4x4(Float64).perspective(*args) }

      it "uses the method matching the compiler flags" do
        {% if flag?(:left_handed) %}
          {% if flag?(:z_zero_one) %}
            lh_zo = Geode::Matrix4x4(Float64).perspective_lh_zo(*args)
            is_expected.to eq(lh_zo)
          {% else %}
            lh_no = Geode::Matrix4x4(Float64).perspective_lh_no(*args)
            is_expected.to eq(lh_no)
          {% end %}
        {% else %}
          {% if flag?(:z_zero_one) %}
            rh_zo = Geode::Matrix4x4(Float64).perspective_rh_zo(*args)
            is_expected.to eq(rh_zo)
          {% else %}
            rh_no = Geode::Matrix4x4(Float64).perspective_rh_no(*args)
            is_expected.to eq(rh_no)
          {% end %}
        {% end %}
      end
    end

    describe ".perspective_rh_no" do
      let(fov) { Geode::Degrees.new(45.0) }
      let(aspect) { 800 / 600 }
      let(matrix) { Geode::Matrix4x4(Float64).perspective_rh_no(fov, aspect, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / (Math.tan(fov / 2) * aspect), 0, 0, 0,
          0, 1 / Math.tan(fov / 2), 0, 0,
          0, 0, -101 / 99, -1,
          0, 0, -200 / 99, 0)
      end
    end

    describe ".perspective_rh_zo" do
      let(fov) { Geode::Degrees.new(45.0) }
      let(aspect) { 800 / 600 }
      let(matrix) { Geode::Matrix4x4(Float64).perspective_rh_zo(fov, aspect, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / (Math.tan(fov / 2) * aspect), 0, 0, 0,
          0, 1 / Math.tan(fov / 2), 0, 0,
          0, 0, -100 / 99, -1,
          0, 0, -100 / 99, 0)
      end
    end

    describe ".perspective_lh_no" do
      let(fov) { Geode::Degrees.new(45.0) }
      let(aspect) { 800 / 600 }
      let(matrix) { Geode::Matrix4x4(Float64).perspective_lh_no(fov, aspect, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / (Math.tan(fov / 2) * aspect), 0, 0, 0,
          0, 1 / Math.tan(fov / 2), 0, 0,
          0, 0, 101 / 99, 1,
          0, 0, -200 / 99, 0)
      end
    end

    describe ".perspective_lh_zo" do
      let(fov) { Geode::Degrees.new(45.0) }
      let(aspect) { 800 / 600 }
      let(matrix) { Geode::Matrix4x4(Float64).perspective_lh_zo(fov, aspect, 1.0, 100.0) }

      it "produces the correct matrix" do
        expect_within_tolerance(matrix,
          1 / (Math.tan(fov / 2) * aspect), 0, 0, 0,
          0, 1 / Math.tan(fov / 2), 0, 0,
          0, 0, 100 / 99, 1,
          0, 0, -100 / 99, 0)
      end
    end
  end
end
