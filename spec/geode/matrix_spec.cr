require "../spec_helper"

Spectator.describe Geode::Matrix do
  TOLERANCE = 0.000000000000001

  subject(matrix) { Geode::Matrix[[1, 2, 3], [4, 5, 6]] }

  it "stores values for elements" do
    aggregate_failures do
      expect(matrix[0, 0]).to eq(1)
      expect(matrix[0, 1]).to eq(2)
      expect(matrix[0, 2]).to eq(3)
      expect(matrix[1, 0]).to eq(4)
      expect(matrix[1, 1]).to eq(5)
      expect(matrix[1, 2]).to eq(6)
    end
  end

  describe "#initialize" do
    it "accepts a flat list of elements" do
      matrix = Geode::Matrix(Int32, 2, 3).new({1, 2, 3, 4, 5, 6})

      aggregate_failures do
        expect(matrix[0, 0]).to eq(1)
        expect(matrix[0, 1]).to eq(2)
        expect(matrix[0, 2]).to eq(3)
        expect(matrix[1, 0]).to eq(4)
        expect(matrix[1, 1]).to eq(5)
        expect(matrix[1, 2]).to eq(6)
      end
    end

    it "accepts a list of rows" do
      matrix = Geode::Matrix(Int32, 2, 3).new({ {1, 2, 3}, {4, 5, 6} })

      aggregate_failures do
        expect(matrix[0, 0]).to eq(1)
        expect(matrix[0, 1]).to eq(2)
        expect(matrix[0, 2]).to eq(3)
        expect(matrix[1, 0]).to eq(4)
        expect(matrix[1, 1]).to eq(5)
        expect(matrix[1, 2]).to eq(6)
      end
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Matrix(Int32, 2, 3).zero }

    it "returns a zero matrix" do
      expect(zero).to eq(Geode::Matrix[[0, 0, 0], [0, 0, 0]])
    end
  end

  describe ".identity" do
    subject(identity) { Geode::Matrix(Int32, 3, 3).identity }

    it "returns an identity matrix" do
      expect(identity).to eq(Geode::Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]])
    end
  end

  describe "#map" do
    it "creates a matrix" do
      mapped = matrix.map(&.itself)
      expect(mapped).to be_a(Geode::Matrix(Int32, 2, 3))
    end

    it "uses the new values" do
      mapped = matrix.map { |e| e.to_f * 2 }
      expect(mapped).to eq(Geode::Matrix[[2.0, 4.0, 6.0], [8.0, 10.0, 12.0]])
    end
  end

  describe "#to_slice" do
    it "is the size of the matrix" do
      slice = matrix.to_slice
      expect(slice.size).to eq(6)
    end

    it "contains the elements" do
      slice = matrix.to_slice
      expect(slice).to eq(Slice[1, 2, 3, 4, 5, 6])
    end
  end

  describe "#to_unsafe" do
    it "references the elements" do
      pointer = matrix.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(1)
        expect(pointer[1]).to eq(2)
        expect(pointer[2]).to eq(3)
        expect(pointer[3]).to eq(4)
        expect(pointer[4]).to eq(5)
        expect(pointer[5]).to eq(6)
      end
    end
  end

  context Geode::CommonMatrix do
    describe "#rows" do
      subject { matrix.rows }

      it "is the correct value" do
        is_expected.to eq(2)
      end
    end

    describe "#columns" do
      subject { matrix.columns }

      it "is the correct value" do
        is_expected.to eq(3)
      end
    end

    describe "#size" do
      subject { matrix.size }

      it "is the correct value" do
        is_expected.to eq(6)
      end
    end

    describe "#square?" do
      subject { matrix.square? }

      context "with a square matrix" do
        let(matrix) { Geode::Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

        it "is true" do
          is_expected.to be_true
        end
      end

      context "with a non-square matrix" do
        let(matrix) { Geode::Matrix[[1, 2, 3], [4, 5, 6]] }

        it "is false" do
          is_expected.to be_false
        end
      end
    end

    describe "#each_indices" do
      it "yields each combination of indices" do
        indices = [] of Tuple(Int32, Int32)
        matrix.each_indices do |i, j|
          indices << {i, j}
        end
        expect(indices).to eq([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}])
      end
    end

    describe "#each_with_indices" do
      it "yields each element with its indices" do
        indices = [] of Tuple(Int32, Int32, Int32)
        matrix.each_with_indices do |e, i, j|
          indices << {e, i, j}
        end
        expect(indices).to eq([{1, 0, 0}, {2, 0, 1}, {3, 0, 2}, {4, 1, 0}, {5, 1, 1}, {6, 1, 2}])
      end
    end

    describe "#map_with_index" do
      it "creates a matrix" do
        mapped = matrix.map_with_index(&.itself)
        expect(mapped).to be_a(Geode::Matrix(Int32, 2, 3))
      end

      it "uses the new values" do
        mapped = matrix.map_with_index { |e, i| e.to_f * i }
        expect(mapped).to eq(Geode::Matrix[[0.0, 2.0, 6.0], [12.0, 20.0, 30.0]])
      end

      it "adds the offset" do
        mapped = matrix.map_with_index(3) { |e, i| e * i }
        expect(mapped).to eq(Geode::Matrix[[3, 8, 15], [24, 35, 48]])
      end
    end

    describe "#map_with_indices" do
      it "creates a matrix" do
        mapped = matrix.map_with_indices(&.itself)
        expect(mapped).to be_a(Geode::Matrix(Int32, 2, 3))
      end

      it "uses the new values" do
        mapped = matrix.map_with_indices { |e, i, j| e.to_f * i + j }
        expect(mapped).to eq(Geode::Matrix[[0.0, 1.0, 2.0], [4.0, 6.0, 8.0]])
      end
    end

    describe "#zip_map" do
      it "iterates two matrices" do
        m1 = Geode::Matrix[[5, 8], [9, 16]]
        m2 = Geode::Matrix[[5, 4], [3, 4]]
        result = m1.zip_map(m2) { |a, b| a // b }
        expect(result).to eq(Geode::Matrix[[1, 2], [3, 4]])
      end

      describe "#each_row" do
        it "enumerates each row" do
          rows = [] of Geode::CommonVector(Int32, 3)
          matrix.each_row { |row| rows << row }
          expect(rows).to eq([Geode::Vector[1, 2, 3], Geode::Vector[4, 5, 6]])
        end
      end

      describe "#each_row_with_index" do
        it "enumerates each row" do
          rows = [] of Tuple(Geode::CommonVector(Int32, 3), Int32)
          matrix.each_row_with_index { |row, i| rows << {row, i} }
          expect(rows).to eq([{Geode::Vector[1, 2, 3], 0}, {Geode::Vector[4, 5, 6], 1}])
        end

        it "applies the offset" do
          rows = [] of Tuple(Geode::CommonVector(Int32, 3), Int32)
          matrix.each_row_with_index(5) { |row, i| rows << {row, i} }
          expect(rows).to eq([{Geode::Vector[1, 2, 3], 5}, {Geode::Vector[4, 5, 6], 6}])
        end
      end

      describe "#each_column" do
        it "enumerates each column" do
          columns = [] of Geode::CommonVector(Int32, 2)
          matrix.each_column { |column| columns << column }
          expect(columns).to eq([Geode::Vector[1, 4], Geode::Vector[2, 5], Geode::Vector[3, 6]])
        end
      end

      describe "#each_column_with_index" do
        it "enumerates each column" do
          columns = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
          matrix.each_column_with_index { |column, i| columns << {column, i} }
          expect(columns).to eq([{Geode::Vector[1, 4], 0}, {Geode::Vector[2, 5], 1}, {Geode::Vector[3, 6], 2}])
        end

        it "applies the offset" do
          columns = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
          matrix.each_column_with_index(5) { |column, i| columns << {column, i} }
          expect(columns).to eq([{Geode::Vector[1, 4], 5}, {Geode::Vector[2, 5], 6}, {Geode::Vector[3, 6], 7}])
        end
      end

      describe "#[]" do
        context "with a flat index" do
          it "returns the correct element" do
            expect(matrix[4]).to eq(5)
          end

          it "raises for an out-of-bound index" do
            expect { matrix[20] }.to raise_error(IndexError)
          end
        end

        context "with two indices" do
          it "returns the correct value" do
            expect(matrix[1, 2]).to eq(6)
          end

          it "raises for out-of-bound indices" do
            expect { matrix[3, 3] }.to raise_error(IndexError)
          end
        end
      end

      describe "#[]?" do
        context "with a flat index" do
          it "returns the correct element" do
            expect(matrix[4]?).to eq(5)
          end

          it "returns nil for an out-of-bound index" do
            expect(matrix[20]?).to be_nil
          end
        end

        context "with two indices" do
          it "returns the correct value" do
            expect(matrix[1, 2]?).to eq(6)
          end

          it "returns nil for out-of-bound indices" do
            expect(matrix[3, 3]?).to be_nil
          end
        end
      end

      describe "#row" do
        it "returns the correct elements" do
          expect(matrix.row(1)).to eq(Geode::Vector[4, 5, 6])
        end

        it "raises for an out-of-bounds index" do
          expect { matrix.row(3) }.to raise_error(IndexError)
        end
      end

      describe "#row?" do
        it "returns the correct elements" do
          expect(matrix.row?(1)).to eq(Geode::Vector[4, 5, 6])
        end

        it "return nil for an out-of-bounds index" do
          expect(matrix.row?(3)).to be_nil
        end
      end

      describe "#column" do
        it "returns the correct elements" do
          expect(matrix.column(1)).to eq(Geode::Vector[2, 5])
        end

        it "raises for an out-of-bounds index" do
          expect { matrix.column(3) }.to raise_error(IndexError)
        end
      end

      describe "#column?" do
        it "returns the correct elements" do
          expect(matrix.column?(1)).to eq(Geode::Vector[2, 5])
        end

        it "return nil for an out-of-bounds index" do
          expect(matrix.column?(3)).to be_nil
        end
      end

      describe "#rows_at" do
        let(matrix) { Geode::Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

        it "returns the correct rows" do
          expect(matrix.rows_at(2, 0)).to eq({Geode::Vector[7, 8, 9], Geode::Vector[1, 2, 3]})
        end
      end

      describe "#columns_at" do
        let(matrix) { Geode::Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

        it "returns the correct columns" do
          expect(matrix.columns_at(2, 0)).to eq({Geode::Vector[3, 6, 9], Geode::Vector[1, 4, 7]})
        end
      end

      describe "#to_rows" do
        subject { matrix.to_rows }

        it "returns row vectors in an array" do
          is_expected.to eq([Geode::Vector[1, 2, 3], Geode::Vector[4, 5, 6]])
        end
      end

      describe "#to_columns" do
        subject { matrix.to_columns }

        it "returns column vectors in an array" do
          is_expected.to eq([Geode::Vector[1, 4], Geode::Vector[2, 5], Geode::Vector[3, 6]])
        end
      end

      describe "#to_s" do
        subject { matrix.to_s }

        it "contains the elements" do
          aggregate_failures do
            is_expected.to contain("1")
            is_expected.to contain("2")
            is_expected.to contain("3")
            is_expected.to contain("4")
            is_expected.to contain("5")
            is_expected.to contain("6")
          end
        end

        it "is formatted correctly" do
          is_expected.to match(/^\[\[\d+, \d+, \d+\], \[\d+, \d+, \d+\]\]$/)
        end
      end
    end
  end
end
