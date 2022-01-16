require "../spec_helper"

Spectator.describe Geode::Matrix1x3 do
  TOLERANCE = 0.000000000000001

  subject(matrix) { Geode::Matrix1x3[[3, 5, 7]] }

  it "stores values for elements" do
    aggregate_failures do
      expect(matrix[0, 0]).to eq(3)
      expect(matrix[0, 1]).to eq(5)
      expect(matrix[0, 2]).to eq(7)
    end
  end

  describe "#initialize" do
    it "accepts a flat list of elements" do
      matrix = Geode::Matrix1x3.new({3, 5, 7})
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[0, 2]).to eq(7)
      end
    end

    it "accepts a list of rows" do
      matrix = Geode::Matrix1x3.new({ {3, 5, 7} })
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[0, 2]).to eq(7)
      end
    end

    it "accepts another matrix" do
      other = Geode::Matrix[[3, 5, 7]]
      matrix = Geode::Matrix1x3.new(other)
      aggregate_failures do
        expect(matrix[0, 0]).to eq(3)
        expect(matrix[0, 1]).to eq(5)
        expect(matrix[0, 2]).to eq(7)
      end
    end
  end

  describe ".zero" do
    subject(zero) { Geode::Matrix1x3(Int32).zero }

    it "returns a zero matrix" do
      expect(zero).to eq(Geode::Matrix1x3[[0, 0, 0]])
    end
  end

  describe "#map" do
    it "creates a matrix" do
      mapped = matrix.map(&.itself)
      expect(mapped).to be_a(Geode::Matrix1x3(Int32))
    end

    it "uses the new values" do
      mapped = matrix.map { |e| e.to_f * 2 }
      expect(mapped).to eq(Geode::Matrix1x3[[6.0, 10.0, 14.0]])
    end
  end

  describe "#transpose" do
    subject { matrix.transpose }

    it "transposes the matrix" do
      is_expected.to eq(Geode::Matrix3x1[[3], [5], [7]])
    end
  end

  describe "#*(matrix)" do
    let(m1) { Geode::Matrix1x3[[3, 5, 7]] }
    subject { m1 * m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2], [3, 4], [5, 6]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[53, 68]])
      end
    end

    context "with a 3x1 matrix" do
      let(m2) { Geode::Matrix3x1[[1], [2], [3]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34]])
      end
    end

    context "with a 3x2 matrix" do
      let(m2) { Geode::Matrix3x2[[1, 10], [2, 20], [3, 30]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340]])
      end
    end

    context "with a 3x3 matrix" do
      let(m2) { Geode::Matrix3x3[[1, 10, 100], [2, 20, 200], [3, 30, 300]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340, 3400]])
      end
    end

    context "with a 3x4 matrix" do
      let(m2) { Geode::Matrix3x4[[1, 10, 100, 1000], [2, 20, 200, 2000], [3, 30, 300, 3000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340, 3400, 34000]])
      end
    end
  end

  describe "#&*(matrix)" do
    let(m1) { Geode::Matrix1x3[[3, 5, 7]] }
    subject { m1 &* m2 }

    context "with a generic matrix" do
      let(m2) { Geode::Matrix[[1, 2], [3, 4], [5, 6]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[53, 68]])
      end
    end

    context "with a 3x1 matrix" do
      let(m2) { Geode::Matrix3x1[[1], [2], [3]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34]])
      end
    end

    context "with a 3x2 matrix" do
      let(m2) { Geode::Matrix3x2[[1, 10], [2, 20], [3, 30]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340]])
      end
    end

    context "with a 3x3 matrix" do
      let(m2) { Geode::Matrix3x3[[1, 10, 100], [2, 20, 200], [3, 30, 300]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340, 3400]])
      end
    end

    context "with a 3x4 matrix" do
      let(m2) { Geode::Matrix3x4[[1, 10, 100, 1000], [2, 20, 200, 2000], [3, 30, 300, 3000]] }

      it "multiplies matrices together" do
        is_expected.to eq(Geode::Matrix[[34, 340, 3400, 34000]])
      end
    end
  end

  describe "#to_slice" do
    it "is the size of the matrix" do
      slice = matrix.to_slice
      expect(slice.size).to eq(3)
    end

    it "contains the elements" do
      slice = matrix.to_slice
      expect(slice).to eq(Slice[3, 5, 7])
    end
  end

  describe "#to_unsafe" do
    it "references the elements" do
      pointer = matrix.to_unsafe
      aggregate_failures do
        expect(pointer[0]).to eq(3)
        expect(pointer[1]).to eq(5)
        expect(pointer[2]).to eq(7)
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

  context Geode::CommonMatrix do
    describe "#rows" do
      subject { matrix.rows }

      it "is the correct value" do
        is_expected.to eq(1)
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
        is_expected.to eq(3)
      end
    end

    describe "#square?" do
      subject { matrix.square? }

      it "is false" do
        is_expected.to be_false
      end
    end

    describe "#each_indices" do
      it "yields each combination of indices" do
        indices = [] of Tuple(Int32, Int32)
        matrix.each_indices do |i, j|
          indices << {i, j}
        end
        expect(indices).to eq([{0, 0}, {0, 1}, {0, 2}])
      end
    end

    describe "#each_with_indices" do
      it "yields each element with its indices" do
        indices = [] of Tuple(Int32, Int32, Int32)
        matrix.each_with_indices do |e, i, j|
          indices << {e, i, j}
        end
        expect(indices).to eq([{3, 0, 0}, {5, 0, 1}, {7, 0, 2}])
      end
    end

    describe "#map_with_index" do
      it "creates a Matrix1x3" do
        mapped = matrix.map_with_index(&.itself)
        expect(mapped).to be_a(Geode::Matrix1x3(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_index { |e, i| e.to_f * i }
        expect(mapped).to eq(Geode::Matrix1x3[[0.0, 5.0, 14.0]])
      end

      it "adds the offset" do
        mapped = matrix.map_with_index(3) { |e, i| e * i }
        expect(mapped).to eq(Geode::Matrix1x3[[9, 20, 35]])
      end
    end

    describe "#map_with_indices" do
      it "creates a Matrix1x3" do
        mapped = matrix.map_with_indices(&.itself)
        expect(mapped).to be_a(Geode::Matrix1x3(Int32))
      end

      it "uses the new values" do
        mapped = matrix.map_with_indices { |e, i, j| e.to_f * i + j }
        expect(mapped).to eq(Geode::Matrix1x3[[0.0, 1.0, 2.0]])
      end
    end

    describe "#zip_map" do
      it "iterates two matrices" do
        m1 = Geode::Matrix1x3[[6, 4, 9]]
        m2 = Geode::Matrix1x3[[3, 4, 3]]
        result = m1.zip_map(m2) { |a, b| a // b }
        expect(result).to eq(Geode::Matrix1x3[[2, 1, 3]])
      end
    end

    describe "#each_row" do
      it "enumerates each row" do
        rows = [] of Geode::CommonVector(Int32, 3)
        matrix.each_row { |row| rows << row }
        expect(rows).to eq([Geode::Vector[3, 5, 7]])
      end
    end

    describe "#each_row_with_index" do
      it "enumerates each row" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 3), Int32)
        matrix.each_row_with_index { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[3, 5, 7], 0}])
      end

      it "applies the offset" do
        rows = [] of Tuple(Geode::CommonVector(Int32, 3), Int32)
        matrix.each_row_with_index(5) { |row, i| rows << {row, i} }
        expect(rows).to eq([{Geode::Vector[3, 5, 7], 5}])
      end
    end

    describe "#each_column" do
      it "enumerates each column" do
        columns = [] of Geode::CommonVector(Int32, 1)
        matrix.each_column { |column| columns << column }
        expect(columns).to eq([Geode::Vector[3], Geode::Vector[5], Geode::Vector[7]])
      end
    end

    describe "#each_column_with_index" do
      it "enumerates each column" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 1), Int32)
        matrix.each_column_with_index { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[3], 0}, {Geode::Vector[5], 1}, {Geode::Vector[7], 2}])
      end

      it "applies the offset" do
        columns = [] of Tuple(Geode::CommonVector(Int32, 1), Int32)
        matrix.each_column_with_index(3) { |column, i| columns << {column, i} }
        expect(columns).to eq([{Geode::Vector[3], 3}, {Geode::Vector[5], 4}, {Geode::Vector[7], 5}])
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
          expect(matrix[0, 1]).to eq(5)
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
          expect(matrix[0, 1]?).to eq(5)
        end

        it "returns nil for out-of-bound indices" do
          expect(matrix[3, 3]?).to be_nil
        end
      end
    end

    describe "#row" do
      it "returns the correct elements" do
        expect(matrix.row(0)).to eq(Geode::Vector[3, 5, 7])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.row(3) }.to raise_error(IndexError)
      end
    end

    describe "#row?" do
      it "returns the correct elements" do
        expect(matrix.row?(0)).to eq(Geode::Vector[3, 5, 7])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.row?(3)).to be_nil
      end
    end

    describe "#column" do
      it "returns the correct elements" do
        expect(matrix.column(1)).to eq(Geode::Vector[5])
      end

      it "raises for an out-of-bounds index" do
        expect { matrix.column(3) }.to raise_error(IndexError)
      end
    end

    describe "#column?" do
      it "returns the correct elements" do
        expect(matrix.column?(1)).to eq(Geode::Vector[5])
      end

      it "return nil for an out-of-bounds index" do
        expect(matrix.column?(3)).to be_nil
      end
    end

    describe "#rows_at" do
      it "returns the correct rows" do
        expect(matrix.rows_at(0)).to eq({Geode::Vector[3, 5, 7]})
      end
    end

    describe "#columns_at" do
      it "returns the correct columns" do
        expect(matrix.columns_at(0, 1)).to eq({Geode::Vector[3], Geode::Vector[5]})
      end
    end

    describe "#to_rows" do
      subject { matrix.to_rows }

      it "returns row vectors in an array" do
        is_expected.to eq([Geode::Vector[3, 5, 7]])
      end
    end

    describe "#to_columns" do
      subject { matrix.to_columns }

      it "returns column vectors in an array" do
        is_expected.to eq([Geode::Vector[3], Geode::Vector[5], Geode::Vector[7]])
      end
    end

    describe "#to_s" do
      subject { matrix.to_s }

      it "is formatted correctly" do
        is_expected.to eq("[[3, 5, 7]]")
      end
    end
  end

  context Geode::MatrixComparison do
    let(m1) { Geode::Matrix[[3, 5, 7]] }
    let(m2) { Geode::Matrix[[7, 5, 3]] }

    describe "#compare" do
      it "compares elements" do
        expect(m1.compare(m2)).to eq(Geode::Matrix[[-1, 0, 1]])
      end
    end

    describe "#eq?" do
      it "compares elements" do
        expect(m1.eq?(m2)).to eq(Geode::Matrix[[false, true, false]])
      end
    end

    describe "#lt?" do
      it "compares elements" do
        expect(m1.lt?(m2)).to eq(Geode::Matrix[[true, false, false]])
      end
    end

    describe "#le?" do
      it "compares elements" do
        expect(m1.le?(m2)).to eq(Geode::Matrix[[true, true, false]])
      end
    end

    describe "#gt?" do
      it "compares elements" do
        expect(m1.gt?(m2)).to eq(Geode::Matrix[[false, false, true]])
      end
    end

    describe "#ge?" do
      it "compares elements" do
        expect(m1.ge?(m2)).to eq(Geode::Matrix[[false, true, true]])
      end
    end

    describe "#zero?" do
      subject { matrix.zero? }

      context "with a zero matrix" do
        let(matrix) { Geode::Matrix1x3(Int32).zero }

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
        let(matrix) { Geode::Matrix1x3[[0.05, 0.1, 0.0]] }

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
          let(other) { Geode::Matrix[[3, 5, 7]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix[[7, 5, 3]] }

          it "returns false" do
            is_expected.to be_false
          end
        end

        context "with a different sized matrix" do
          let(other) { Geode::Matrix[[1, 2], [3, 4]] }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end

      context "with a nxm-dimension matrix" do
        context "with equal values" do
          let(other) { Geode::Matrix1x3[[3, 5, 7]] }

          it "returns true" do
            is_expected.to be_true
          end
        end

        context "with unequal values" do
          let(other) { Geode::Matrix1x3[[7, 5, 3]] }

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
        expect(subject.to_a).to eq([{0, 0}, {0, 1}, {0, 2}])
      end
    end

    describe "#each_with_indices" do
      subject { matrix.each_with_indices }

      it "iterates through each element and its indices" do
        expect(subject.to_a).to eq([{3, 0, 0}, {5, 0, 1}, {7, 0, 2}])
      end
    end

    describe "#each_row" do
      subject { matrix.each_row }

      it "iterates through each row" do
        expect(subject.to_a).to eq([Geode::Vector[3, 5, 7]])
      end
    end

    describe "#each_row_with_index" do
      subject { matrix.each_row_with_index }

      it "iterates through each row" do
        expect(subject.to_a).to eq([{Geode::Vector[3, 5, 7], 0}])
      end

      context "with an offset" do
        subject { matrix.each_row_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[3, 5, 7], 3}])
        end
      end
    end

    describe "#each_column" do
      subject { matrix.each_column }

      it "iterates through each column" do
        expect(subject.to_a).to eq([Geode::Vector[3], Geode::Vector[5], Geode::Vector[7]])
      end
    end

    describe "#each_column_with_index" do
      subject { matrix.each_column_with_index }

      it "iterates through each column" do
        expect(subject.to_a).to eq([{Geode::Vector[3], 0}, {Geode::Vector[5], 1}, {Geode::Vector[7], 2}])
      end

      context "with an offset" do
        subject { matrix.each_column_with_index(3) }

        it "applies the offset" do
          expect(subject.to_a).to eq([{Geode::Vector[3], 3}, {Geode::Vector[5], 4}, {Geode::Vector[7], 5}])
        end
      end
    end
  end

  context Geode::MatrixOperations do
    describe "#abs" do
      it "returns the absolute value" do
        expect(Geode::Matrix1x3[[3, -5, 0]].abs).to eq(Geode::Matrix1x3[[3, 5, 0]])
      end
    end

    describe "#abs2" do
      it "returns the absolute value squared" do
        expect(Geode::Matrix1x3[[3, -5, 0]].abs2).to eq(Geode::Matrix1x3[[9, 25, 0]])
      end
    end

    describe "#round" do
      it "rounds the elements" do
        expect(Geode::Matrix1x3[[1.2, -5.7, 1.5]].round).to eq(Geode::Matrix1x3[[1.0, -6.0, 2.0]])
      end

      context "with digits" do
        it "rounds the elements" do
          expect(Geode::Matrix1x3[[1.25, -5.77, 1.5]].round(1)).to eq(Geode::Matrix1x3[[1.2, -5.8, 1.5]])
        end
      end
    end

    describe "#sign" do
      it "returns the sign of each element" do
        expect(Geode::Matrix1x3[[5, -5, 0]].sign).to eq(Geode::Matrix1x3[[1, -1, 0]])
      end
    end

    describe "#ceil" do
      it "returns the elements rounded up" do
        expect(Geode::Matrix1x3[[1.2, -5.7, 1.5]].ceil).to eq(Geode::Matrix1x3[[2.0, -5.0, 2.0]])
      end
    end

    describe "#floor" do
      it "returns the elements rounded down" do
        expect(Geode::Matrix1x3[[1.2, -5.7, 1.5]].floor).to eq(Geode::Matrix1x3[[1.0, -6.0, 1.0]])
      end
    end

    describe "#fraction" do
      it "returns the fraction part of each element" do
        fraction = Geode::Matrix1x3[[1.2, -5.7, 0.5]].fraction
        aggregate_failures do
          expect(fraction[0, 0]).to be_within(TOLERANCE).of(0.2)
          expect(fraction[0, 1]).to be_within(TOLERANCE).of(0.3)
          expect(fraction[0, 2]).to be_within(TOLERANCE).of(0.5)
        end
      end
    end

    describe "#clamp" do
      context "with a min and max matrices" do
        it "restricts elements" do
          min = Geode::Matrix1x3[[-1, -2, -3]]
          max = Geode::Matrix1x3[[1, 2, 3]]
          expect(Geode::Matrix1x3[[-2, 3, 1]].clamp(min, max)).to eq(Geode::Matrix1x3[[-1, 2, 1]])
        end
      end

      context "with a range of matrices" do
        it "restricts elements" do
          min = Geode::Matrix1x3[[-1, -2, -3]]
          max = Geode::Matrix1x3[[1, 2, 3]]
          expect(Geode::Matrix1x3[[-2, 3, 1]].clamp(min..max)).to eq(Geode::Matrix1x3[[-1, 2, 1]])
        end
      end

      context "with a min and max" do
        it "restricts elements" do
          expect(Geode::Matrix1x3[[-2, 2, 0]].clamp(-1, 1)).to eq(Geode::Matrix1x3[[-1, 1, 0]])
        end
      end

      context "with a range" do
        it "restricts elements" do
          expect(Geode::Matrix1x3[[-2, 2, 0]].clamp(-1..1)).to eq(Geode::Matrix1x3[[-1, 1, 0]])
        end
      end
    end

    describe "#edge" do
      context "with a scalar value" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(4)).to eq(Geode::Matrix1x3[[0, 1, 1]])
        end
      end

      context "with a matrix" do
        it "returns correct zero and one elements" do
          expect(matrix.edge(Geode::Matrix1x3[[2, 9, 7]])).to eq(Geode::Matrix1x3[[1, 0, 1]])
        end
      end
    end

    describe "#scale" do
      context "with a matrix" do
        let(other) { Geode::Matrix1x3[[3, 4, 5]] }

        it "scales each element separately" do
          expect(matrix.scale(other)).to eq(Geode::Matrix1x3[[9, 20, 35]])
        end
      end

      context "with a scalar" do
        it "scales each element by the same amount" do
          expect(matrix.scale(5)).to eq(Geode::Matrix1x3[[15, 25, 35]])
        end
      end
    end

    describe "#scale!" do
      context "with a matrix" do
        let(other) { Geode::Matrix1x3[[3, 4, 5]] }

        it "scales each element separately" do
          expect(matrix.scale!(other)).to eq(Geode::Matrix1x3[[9, 20, 35]])
        end
      end

      context "with a scalar" do
        it "scales each element by the same amount" do
          expect(matrix.scale!(5)).to eq(Geode::Matrix1x3[[15, 25, 35]])
        end
      end
    end

    describe "#lerp" do
      let(m1) { Geode::Matrix1x3[[5.0, 7.0, 9.0]] }
      let(m2) { Geode::Matrix1x3[[25.0, 37.0, 49.0]] }

      it "returns m1 when t = 0" do
        matrix = m1.lerp(m2, 0.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(5.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(7.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(9.0)
        end
      end

      it "returns m2 when t = 1" do
        matrix = m1.lerp(m2, 1.0)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(25.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(37.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(49.0)
        end
      end

      it "returns a mid-value" do
        matrix = m1.lerp(m2, 0.4)
        aggregate_failures do
          expect(matrix[0, 0]).to be_within(TOLERANCE).of(13.0)
          expect(matrix[0, 1]).to be_within(TOLERANCE).of(19.0)
          expect(matrix[0, 2]).to be_within(TOLERANCE).of(25.0)
        end
      end
    end

    describe "#- (negation)" do
      it "negates the matrix" do
        expect(-Geode::Matrix1x3[[3, -3, 0]]).to eq(Geode::Matrix1x3[[-3, 3, 0]])
      end
    end

    describe "#+" do
      it "adds two matrices" do
        m1 = Geode::Matrix1x3[[5, 7, 9]]
        m2 = Geode::Matrix1x3[[2, 4, -3]]
        expect(m1 + m2).to eq(Geode::Matrix1x3[[7, 11, 6]])
      end
    end

    describe "#&+" do
      it "adds two matrices" do
        m1 = Geode::Matrix1x3[[5, 7, 9]]
        m2 = Geode::Matrix1x3[[2, 4, -3]]
        expect(m1 &+ m2).to eq(Geode::Matrix1x3[[7, 11, 6]])
      end
    end

    describe "#-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix1x3[[5, 7, -3]]
        m2 = Geode::Matrix1x3[[2, 5, -4]]
        expect(m1 - m2).to eq(Geode::Matrix1x3[[3, 2, 1]])
      end
    end

    describe "#&-" do
      it "subtracts two matrices" do
        m1 = Geode::Matrix1x3[[5, 7, -3]]
        m2 = Geode::Matrix1x3[[2, 5, -4]]
        expect(m1 &- m2).to eq(Geode::Matrix1x3[[3, 2, 1]])
      end
    end

    describe "#*(number)" do
      it "scales a matrix" do
        expect(matrix * 3).to eq(Geode::Matrix1x3[[9, 15, 21]])
      end
    end

    describe "#&*(number)" do
      it "scales a matrix" do
        expect(matrix &* 3).to eq(Geode::Matrix1x3[[9, 15, 21]])
      end
    end

    describe "#/" do
      it "scales a matrix" do
        matrix = Geode::Matrix1x3[[4.0, 6.0, 8.0]]
        expect(matrix / 2).to eq(Geode::Matrix1x3[[2.0, 3.0, 4.0]])
      end
    end

    describe "#//" do
      it "scales the matrix" do
        matrix = Geode::Matrix1x3[[4, 6, 8]]
        expect(matrix // 2).to eq(Geode::Matrix1x3[[2, 3, 4]])
      end
    end
  end

  context Geode::MatrixVectors do
    describe "#row?" do
      subject { matrix.row? }

      it "is true" do
        is_expected.to be_true
      end
    end

    describe "#column?" do
      subject { matrix.column? }

      it "is false" do
        is_expected.to be_false
      end
    end

    describe "#to_vector" do
      subject { matrix.to_vector }

      it "returns a vector" do
        is_expected.to eq(Geode::Vector[3, 5, 7])
      end
    end
  end
end
