require "../spec_helper"

Spectator.describe Geode::Matrix2x2 do
  TOLERANCE = 0.000000000000001

  subject(matrix) { Geode::Matrix2x2[[3, 5], [7, 9]] }

  it "stores values for elements" do
    aggregate_failures do
      expect(matrix[0, 0]).to eq(3)
      expect(matrix[0, 1]).to eq(5)
      expect(matrix[1, 0]).to eq(7)
      expect(matrix[1, 1]).to eq(9)
    end
  end

  describe "#initialize" do
    it "accepts a flat list of elements" do
      matrix = Geode::Matrix2x2.new({3, 5, 7, 9})
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[1, 0]).to eq(7)
        expect(matrix[1, 1]).to eq(9)
      end
    end

    it "accepts a list of rows" do
      matrix = Geode::Matrix2x2.new({ {3, 5}, {7, 9} })
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[1, 0]).to eq(7)
        expect(matrix[1, 1]).to eq(9)
      end
    end

    it "accepts another matrix" do
      other = Geode::Matrix[[3, 5], [7, 9]]
      matrix = Geode::Matrix2x2.new(other)
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[1, 0]).to eq(7)
        expect(matrix[1, 1]).to eq(9)
      end
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Matrix2x2(Int32).zero }

    it "returns a zero matrix" do
      expect(zero).to eq(Geode::Matrix2x2[[0, 0], [0, 0]])
    end
  end

  describe "#map" do
    it "creates a matrix" do
      mapped = matrix.map(&.itself)
      expect(mapped).to be_a(Geode::Matrix2x2(Int32))
    end

    it "uses the new values" do
      mapped = matrix.map { |e| e.to_f * 2 }
      expect(mapped).to eq(Geode::Matrix2x2[[6.0, 10.0], [14.0, 18.0]])
    end
  end

  describe "#transpose" do
    subject { matrix.transpose }

    it "transposes the matrix" do
      is_expected.to eq(Geode::Matrix2x2[[3, 7], [5, 9]])
    end
  end

  describe "#sub" do
    let(matrix) { Geode::Matrix2x2[[1, 2], [3, 4]] }
    subject { matrix.sub(1, 1) }

    it "produces a sub-matrix" do
      is_expected.to eq(Geode::Matrix[[1]])
    end
  end

  describe "#*(matrix)" do
    let(m1) { Geode::Matrix2x2[[3, 5], [7, 9]] }
    subject { m1 * m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2, 3], [4, 5, 6]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[23, 31, 39], [43, 59, 75]])
      end
    end

    context "with a 2x1 matrix" do
      let(m2) { Geode::Matrix2x1[[1], [2]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13], [25]])
      end
    end

    context "with a 2x2 matrix" do
      let(m2) { Geode::Matrix2x2[[1, 10], [2, 20]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130], [25, 250]])
      end
    end

    context "with a 2x3 matrix" do
      let(m2) { Geode::Matrix2x3[[1, 10, 100], [2, 20, 200]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130, 1300], [25, 250, 2500]])
      end
    end

    context "with a 2x4 matrix" do
      let(m2) { Geode::Matrix2x4[[1, 10, 100, 1000], [2, 20, 200, 2000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130, 1300, 13000], [25, 250, 2500, 25000]])
      end
    end
  end

  describe "#&*(matrix)" do
    let(m1) { Geode::Matrix2x2[[3, 5], [7, 9]] }
    subject { m1 &* m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2, 3], [4, 5, 6]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[23, 31, 39], [43, 59, 75]])
      end
    end

    context "with a 2x1 matrix" do
      let(m2) { Geode::Matrix2x1[[1], [2]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13], [25]])
      end
    end

    context "with a 2x2 matrix" do
      let(m2) { Geode::Matrix2x2[[1, 10], [2, 20]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130], [25, 250]])
      end
    end

    context "with a 2x3 matrix" do
      let(m2) { Geode::Matrix2x3[[1, 10, 100], [2, 20, 200]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130, 1300], [25, 250, 2500]])
      end
    end

    context "with a 2x4 matrix" do
      let(m2) { Geode::Matrix2x4[[1, 10, 100, 1000], [2, 20, 200, 2000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[13, 130, 1300, 13000], [25, 250, 2500, 25000]])
      end
    end
  end

  describe "#to_slice" do
    it "is the size of the matrix" do
      slice = matrix.to_slice
      expect(slice.size).to eq(4)
    end

    it "contains the elements" do
      slice = matrix.to_slice
      expect(slice).to eq(Slice[3, 5, 7, 9])
    end
  end

  describe "#to_unsafe" do
    it "references the elements" do
      pointer = matrix.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(3)
        expect(pointer[1]).to eq(5)
        expect(pointer[2]).to eq(7)
        expect(pointer[3]).to eq(9)
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

    it "returns element (1, 0)" do
      is_expected.to eq(matrix[1, 0])
    end
  end

  describe "#d" do
    subject { matrix.d }

    it "returns element (1, 1)" do
      is_expected.to eq(matrix[1, 1])
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
        is_expected.to eq(2)
      end
    end

    describe "#size" do
      subject { matrix.size }

      it "is the correct value" do
        is_expected.to eq(4)
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
        expect(indices).to eq([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
      end
    end

    describe "#each_with_indices" do
      it "yields each element with its indices" do
        indices = [] of Tuple(Int32, Int32, Int32)
        matrix.each_with_indices do |e, i, j|
          indices << {e, i, j}
        end
        expect(indices).to eq([{3, 0, 0}, {5, 0, 1}, {7, 1, 0}, {9, 1, 1}])
      end
    end

    describe "#map_with_index" do
      it "creates a Matrix2x2" do
        mapped = matrix.map_with_index(&.itself)
        expect(mapped).to be_a(Geode::Matrix2x2(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_index { |e, i| e.to_f * i }
        expect(mapped).to eq(Geode::Matrix2x2[[0.0, 5.0], [14.0, 27.0]])
      end

      it "adds the offset" do
        mapped = matrix.map_with_index(3) { |e, i| e * i }
        expect(mapped).to eq(Geode::Matrix2x2[[9, 20], [35, 54]])
      end
    end

    describe "#map_with_indices" do
      it "creates a Matrix2x2" do
        mapped = matrix.map_with_indices(&.itself)
        expect(mapped).to be_a(Geode::Matrix2x2(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_indices { |e, i, j| e.to_f * i + j }
        expect(mapped).to eq(Geode::Matrix2x2[[0.0, 1.0], [7.0, 10.0]])
      end
    end

    describe "#zip_map" do
      it "iterates two matrices" do
        m1 = Geode::Matrix2x2[[6, 1], [4, 8]]
        m2 = Geode::Matrix2x2[[3, 1], [4, 2]]
        result = m1.zip_map(m2) { |a, b| a // b }
        expect(result).to eq(Geode::Matrix2x2[[2, 1], [1, 4]])
      end
    end

    describe "#each_row" do
      it "enumerates each row" do
        rows = [] of Geode::CommonVector(Int32, 2)
        matrix.each_row { |row| rows << row }
        expect(rows).to eq([Geode::Vector[3, 5], Geode::Vector[7, 9]])
      end
    end

    describe "#each_row_with_index" do
      it "enumerates each row" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
        matrix.each_row_with_index { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[3, 5], 0}, {Geode::Vector[7, 9], 1}])
      end

      it "applies the offset" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
        matrix.each_row_with_index(5) { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[3, 5], 5}, {Geode::Vector[7, 9], 6}])
      end
    end

    describe "#each_column" do
      it "enumerates each column" do
        columns = [] of Geode::CommonVector(Int32, 2)
        matrix.each_column { |column| columns << column }
        expect(columns).to eq([Geode::Vector[3, 7], Geode::Vector[5, 9]])
      end
    end

    describe "#each_column_with_index" do
      it "enumerates each column" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
        matrix.each_column_with_index { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[3, 7], 0}, {Geode::Vector[5, 9], 1}])
      end

      it "applies the offset" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 2), Int32)
        matrix.each_column_with_index(3) { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[3, 7], 3}, {Geode::Vector[5, 9], 4}])
      end
    end

    describe "#[]" do
      context "with a flat index" do
        it "returns the correct element" do
          expect(matrix[1]).to eq(5)
        end

        it "raises for an out-of-bound index" do
          expect { matrix[20] }.to raise_error(IndexError)
        end
      end

      context "with two indices" do
        it "returns the correct value" do
          expect(matrix[1, 1]).to eq(9)
        end

        it "raises for out-of-bound indices" do
          expect { matrix[3, 3] }.to raise_error(IndexError)
        end
      end
    end

    describe "#[]?" do
      context "with a flat index" do
        it "returns the correct element" do
          expect(matrix[1]?).to eq(5)
        end

        it "returns nil for an out-of-bound index" do
          expect(matrix[20]?).to be_nil
        end
      end

      context "with two indices" do
        it "returns the correct value" do
          expect(matrix[1, 1]?).to eq(9)
        end

        it "returns nil for out-of-bound indices" do
          expect(matrix[3, 3]?).to be_nil
        end
      end
    end

    describe "#row" do
      it "returns the correct elements" do
        expect(matrix.row(1)).to eq(Geode::Vector[7, 9])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.row(3) }.to raise_error(IndexError)
      end
    end

    describe "#row?" do
      it "returns the correct elements" do
        expect(matrix.row?(1)).to eq(Geode::Vector[7, 9])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.row?(3)).to be_nil
      end
    end

    describe "#column" do
      it "returns the correct elements" do
        expect(matrix.column(1)).to eq(Geode::Vector[5, 9])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.column(3) }.to raise_error(IndexError)
      end
    end

    describe "#column?" do
      it "returns the correct elements" do
        expect(matrix.column?(1)).to eq(Geode::Vector[5, 9])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.column?(3)).to be_nil
      end
    end

    describe "#rows_at" do
      it "returns the correct rows" do
        expect(matrix.rows_at(0, 1)).to eq({Geode::Vector[3, 5], Geode::Vector[7, 9]})
      end
    end

    describe "#columns_at" do
      it "returns the correct columns" do
        expect(matrix.columns_at(0, 1)).to eq({Geode::Vector[3, 7], Geode::Vector[5, 9]})
      end
    end

    describe "#to_rows" do
      subject { matrix.to_rows }

      it "returns row vectors in an array" do
        is_expected.to eq([Geode::Vector[3, 5], Geode::Vector[7, 9]])
      end
    end

    describe "#to_columns" do
      subject { matrix.to_columns }

      it "returns column vectors in an array" do
        is_expected.to eq([Geode::Vector[3, 7], Geode::Vector[5, 9]])
      end
    end

    describe "#to_s" do
      subject { matrix.to_s }

      it "is formatted correctly" do
        is_expected.to eq("[[3, 5], [7, 9]]")
      end
    end
  end

  context Geode::MatrixComparison do
    let(m1) { Geode::Matrix[[3, 5], [7, 9]] }
    let(m2) { Geode::Matrix[[5, 3], [7, 0]] }

    describe "#compare" do
      it "compares elements" do
        expect(m1.compare(m2)).to eq(Geode::Matrix[[-1, 1], [0, 1]])
      end
    end

    describe "#eq?" do
      it "compares elements" do
        expect(m1.eq?(m2)).to eq(Geode::Matrix[[false, false], [true, false]])
      end
    end

    describe "#lt?" do
      it "compares elements" do
        expect(m1.lt?(m2)).to eq(Geode::Matrix[[true, false], [false, false]])
      end
    end

    describe "#le?" do
      it "compares elements" do
        expect(m1.le?(m2)).to eq(Geode::Matrix[[true, false], [true, false]])
      end
    end

    describe "#gt?" do
      it "compares elements" do
        expect(m1.gt?(m2)).to eq(Geode::Matrix[[false, true], [false, true]])
      end
    end

    describe "#ge?" do
      it "compares elements" do
        expect(m1.ge?(m2)).to eq(Geode::Matrix[[false, true], [true, true]])
      end
    end

    describe "#zero?" do
      subject { matrix.zero? }

      context "with a zero matrix" do
        let(matrix) { Geode::Matrix2x2(Int32).zero }

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
        let(matrix) { Geode::Matrix2x2[[0.05, 0.0], [0.1, -0.02]] }

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
          let(other) { Geode::Matrix[[3, 5], [7, 9]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix[[5, 3], [9, 7]] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different sized matrix" do
          let(other) { Geode::Matrix[[1, 2, 3], [4, 5, 6]] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end

      context "with a nxm-dimension matrix" do
        context "with equal values" do
          let(other) { Geode::Matrix2x2[[3, 5], [7, 9]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix2x2[[5, 3], [9, 7]] }

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
        expect(subject.to_a).to eq([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
      end
    end

    describe "#each_with_indices" do
      subject { matrix.each_with_indices }

      it "iterates through each element and its indices" do
        expect(subject.to_a).to eq([{3, 0, 0}, {5, 0, 1}, {7, 1, 0}, {9, 1, 1}])
      end
    end

    describe "#each_row" do
      subject { matrix.each_row }

      it "iterates through each row" do
        expect(subject.to_a).to eq([Geode::Vector[3, 5], Geode::Vector[7, 9]])
      end
    end

    describe "#each_row_with_index" do
      subject { matrix.each_row_with_index }

      it "iterates through each row" do
        expect(subject.to_a).to eq([{Geode::Vector[3, 5], 0}, {Geode::Vector[7, 9], 1}])
      end

      context "with an offset" do
        subject { matrix.each_row_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[3, 5], 3}, {Geode::Vector[7, 9], 4}])
        end
      end
    end

    describe "#each_column" do
      subject { matrix.each_column }

      it "iterates through each column" do
        expect(subject.to_a).to eq([Geode::Vector[3, 7], Geode::Vector[5, 9]])
      end
    end

    describe "#each_column_with_index" do
      subject { matrix.each_column_with_index }

      it "iterates through each column" do
        expect(subject.to_a).to eq([{Geode::Vector[3, 7], 0}, {Geode::Vector[5, 9], 1}])
      end

      context "with an offset" do
        subject { matrix.each_column_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[3, 7], 3}, {Geode::Vector[5, 9], 4}])
        end
      end
    end
  end

  context Geode::MatrixOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Matrix2x2[[3, -1], [-5, 0]].abs).to eq(Geode::Matrix2x2[[3, 1], [5, 0]])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Matrix2x2[[3, -1], [-5, 0]].abs2).to eq(Geode::Matrix2x2[[9, 1], [25, 0]])
      end
    end

    describe "#round" do
      it "rounds the elements" do
        expect(Geode::Matrix2x2[[1.2, 3.0], [-5.7, 1.5]].round).to eq(Geode::Matrix2x2[[1.0, 3.0], [-6.0, 2.0]])
      end

      context "with digits" do
        it "rounds the elements" do
          expect(Geode::Matrix2x2[[1.25, 3.01], [-5.77, 1.5]].round(1)).to eq(Geode::Matrix2x2[[1.2, 3.0], [-5.8, 1.5]])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each element" do
        expect(Geode::Matrix2x2[[5, 1], [-5, 0]].sign).to eq(Geode::Matrix2x2[[1, 1], [-1, 0]])
      end
    end

    describe "#ceil" do
      it "returns the elements rounded up" do
        expect(Geode::Matrix2x2[[1.2, 3.0], [-5.7, 1.5]].ceil).to eq(Geode::Matrix2x2[[2.0, 3.0], [-5.0, 2.0]])
      end
    end

    describe "#floor" do
      it "returns the elements rounded down" do
        expect(Geode::Matrix2x2[[1.2, 3.0], [-5.7, 1.5]].floor).to eq(Geode::Matrix2x2[[1.0, 3.0], [-6.0, 1.0]])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each element" do
        fraction = Geode::Matrix2x2[[1.2, 3.0], [-5.7, 1.5]].fraction
        aggregate_failures do
          expect(fraction[0, 0]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[0, 1]).to be_within(TOLERANCE).of(0.0)
          expect(fraction[1, 0]).to be_within(TOLERANCE).of(0.3)
          expect(fraction[1, 1]).to be_within(TOLERANCE).of(0.5)
        end
      end
    end

    describe "#clamp" do
      context "with a min and max matrices" do
        it "restricts elements" do
          min = Geode::Matrix2x2[[-1, -2], [-3, -4]]
          max = Geode::Matrix2x2[[1, 2], [3, 4]]
          expect(Geode::Matrix2x2[[-2, 0], [3, 1]].clamp(min, max)).to eq(Geode::Matrix2x2[[-1, 0], [3, 1]])
        end
      end

      context "with a range of matrices" do
        it "restricts elements" do
          min = Geode::Matrix2x2[[-1, -2], [-3, -4]]
          max = Geode::Matrix2x2[[1, 2], [3, 4]]
          expect(Geode::Matrix2x2[[-2, 0], [3, 1]].clamp(min..max)).to eq(Geode::Matrix2x2[[-1, 0], [3, 1]])
        end
      end

      context "with a min and max" do
        it "restricts elements" do
          expect(Geode::Matrix2x2[[-2, 0], [2, 1]].clamp(-1, 1)).to eq(Geode::Matrix2x2[[-1, 0], [1, 1]])
        end
      end

      context "with a range" do
        it "restricts elements" do
          expect(Geode::Matrix2x2[[-2, 0], [2, 1]].clamp(-1..1)).to eq(Geode::Matrix2x2[[-1, 0], [1, 1]])
        end
      end
    end

    describe "#edge" do
      context "with a scalar value" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(6)).to eq(Geode::Matrix2x2[[0, 0], [1, 1]])
        end
      end

      context "with a matrix" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(Geode::Matrix2x2[[2, 3], [9, 0]])).to eq(Geode::Matrix2x2[[1, 1], [0, 1]])
        end
      end
    end

    describe "#scale" do
      context "with a matrix" do
        let(other) { Geode::Matrix2x2[[2, 3], [4, 5]] }

        it "scales each element separately" do
          expect(matrix.scale(other)).to eq(Geode::Matrix2x2[[6, 15], [28, 45]])
        end
      end

      context "with a scalar" do
        it "scales each element by the same amount" do
          expect(matrix.scale(5)).to eq(Geode::Matrix2x2[[15, 25], [35, 45]])
        end
      end
    end

    describe "#scale!" do
      context "with a matrix" do
        let(other) { Geode::Matrix2x2[[2, 3], [4, 5]] }

        it "scales each element separately" do
          expect(matrix.scale!(other)).to eq(Geode::Matrix2x2[[6, 15], [28, 45]])
        end
      end

      context "with a scalar" do
        it "scales each element by the same amount" do
          expect(matrix.scale!(5)).to eq(Geode::Matrix2x2[[15, 25], [35, 45]])
        end
      end
    end

    describe "#lerp" do
      let(m1) { Geode::Matrix2x2[[3.0, 5.0], [7.0, 9.0]] }
      let(m2) { Geode::Matrix2x2[[13.0, 25.0], [37.0, 49.0]] }

      it "returns m1 when t = 0" do
        matrix = m1.lerp(m2, 0.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(3.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(7.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(9.0)
        end
      end

      it "returns m2 when t = 1" do
        matrix = m1.lerp(m2, 1.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(13.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(25.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(37.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(49.0)
        end
      end

      it "returns a mid-value" do
        matrix = m1.lerp(m2, 0.4)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(7.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(13.0)
          expect(matrix[1, 0]).to be_within(TOLERANCE).of(19.0)
          expect(matrix[1, 1]).to be_within(TOLERANCE).of(25.0)
        end
      end
    end

    describe "#- (negation)" do
      it "negates the matrix" do
        expect(-Geode::Matrix2x2[[3, 1], [-3, 0]]).to eq(Geode::Matrix2x2[[-3, -1], [3, 0]])
      end
    end

    describe "#+" do
      it "adds two matrices" do
        m1 = Geode::Matrix2x2[[5, 1], [7, 2]]
        m2 = Geode::Matrix2x2[[2, 0], [4, 3]]
        expect(m1 + m2).to eq(Geode::Matrix2x2[[7, 1], [11, 5]])
      end
    end

    describe "#&+" do
      it "adds two matrices" do
        m1 = Geode::Matrix2x2[[5, 1], [7, 2]]
        m2 = Geode::Matrix2x2[[2, 0], [4, 3]]
        expect(m1 &+ m2).to eq(Geode::Matrix2x2[[7, 1], [11, 5]])
      end
    end

    describe "#-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix2x2[[5, 1], [7, 8]]
        m2 = Geode::Matrix2x2[[2, 0], [5, 4]]
        expect(m1 - m2).to eq(Geode::Matrix2x2[[3, 1], [2, 4]])
      end
    end

    describe "#&-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix2x2[[5, 1], [7, 8]]
        m2 = Geode::Matrix2x2[[2, 0], [5, 4]]
        expect(m1 &- m2).to eq(Geode::Matrix2x2[[3, 1], [2, 4]])
      end
    end

    describe "#*(number)" do
      it "scales a matrix" do
        expect(matrix * 3).to eq(Geode::Matrix2x2[[9, 15], [21, 27]])
      end
    end

    describe "#&*(number)" do
      it "scales a matrix" do
        expect(matrix &* 3).to eq(Geode::Matrix2x2[[9, 15], [21, 27]])
      end
    end

    describe "#/" do
      it "scales a matrix" do
        matrix = Geode::Matrix2x2[[4.0, 2.0], [6.0, 0.0]]
        expect(matrix / 2).to eq(Geode::Matrix2x2[[2.0, 1.0], [3.0, 0.0]])
      end
    end

    describe "#//" do
      it "scales the matrix" do
        matrix = Geode::Matrix2x2[[4, 2], [6, 1]]
        expect(matrix // 2).to eq(Geode::Matrix2x2[[2, 1], [3, 0]])
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

    context Geode::SquareMatrix do
      describe "#diagonal" do
        subject { matrix.diagonal }

        it "returns the diagonal elements" do
          is_expected.to eq(Geode::Vector[3, 9])
        end
      end

      describe "#each_diagonal (block)" do
        it "iterates over the diagonal" do
          elements = [] of Int32
          matrix.each_diagonal { |e| elements << e }
          expect(elements).to eq([3, 9])
        end
      end

      describe "#each_diagonal (iterator)" do
        subject { matrix.each_diagonal }

        it "iterates over the diagonal" do
          expect(subject.to_a).to eq([3, 9])
        end
      end

      describe "#trace" do
        subject { matrix.trace }

        it "is the sum of the diagonal" do
          is_expected.to eq(12)
        end
      end

      describe "#determinant" do
        subject { matrix.determinant }

        it "computes the determinant" do
          is_expected.to eq(-8)
        end
      end
    end
  end
end
