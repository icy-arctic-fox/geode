module Geode
  # Iterator methods for matrices.
  #
  # Intended to be used as a mix-in on matrix types.
  # *T* is the type of each element in the matrix.
  # *M* and *N* are positive integers indicating the number of rows and columns respectively.
  module MatrixIterators(T, M, N)
    # Returns an iterator that enumerates through each of the indices (not the elements).
    #
    # Yields for each index combination in the matrix.
    # Two arguments are supplied to the block: *i* and *j*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].each_indices.to_a
    # # => [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
    # ```
    def each_indices
      IndicesIterator(M, N).new
    end

    # Iterator for enumerating through matrix indices.
    private class IndicesIterator(M, N)
      include Iterator(Tuple(Int32, Int32))

      @i = 0
      @j = 0

      # Retrieves the next set of indices.
      def next
        i = @i
        j = @j
        return stop if i >= M

        @j += 1
        if @j >= N
          @j = 0
          @i += 1
        end

        {i, j}
      end
    end

    # Returns an iterator that enumerates through each element and its indices.
    #
    # Yields for each element in the matrix.
    # Three arguments are supplied to the block: the element, *i*, and *j*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].each_with_indices.to_a
    # # => [{0, 0, 0}, {1, 0, 1}, {2, 1, 0}, {3, 1, 1}]
    # ```
    def each_with_indices
      ElementIndicesIterator(T, M, N, typeof(self)).new(self)
    end

    # Iterator for enumerating through matrix elements and their indices.
    private class ElementIndicesIterator(T, M, N, A)
      include Iterator(Tuple(T, Int32, Int32))

      @i = 0
      @j = 0
      @index = 0

      # Creates the iterator.
      #
      # Requires the source *matrix*.
      def initialize(@matrix : A)
      end

      # Retrieves the next element and its indices.
      def next
        i = @i
        j = @j
        index = @index
        return stop if i >= M

        @index += 1
        @j += 1
        if @j >= N
          @j = 0
          @i += 1
        end

        value = @matrix.unsafe_fetch(index)
        {value, i, j}
      end
    end

    # Returns an iterator that enumerates through each row of the matrix.
    #
    # Yields a vector with the elements from the current row.
    # The size of the vector is equal to the number of columns.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_row.to_a
    # # => [(1, 2, 3), (4, 5, 6)]
    # ```
    def each_row
      RowIterator(T, M, N, typeof(self)).new(self)
    end

    # Iterator for enumerating through rows in a matrix.
    private class RowIterator(T, M, N, A)
      include Iterator(CommonVector(T, N))

      @i = 0

      # Creates the iterator.
      #
      # Requires the source *matrix*.
      def initialize(@matrix : A)
      end

      # Retrieves the next row.
      def next
        return stop if @i >= M

        @matrix.unsafe_fetch_row(@i).tap { @i += 1 }
      end
    end

    # Returns an iterator that enumerates through each row of the matrix.
    #
    # Yields a vector with the elements from the current row and the row index.
    # The size of the vector is equal to the number of columns.
    # An *offset* can be specified, which is added to the yielded row index.
    # This does not affect the starting row.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_row_with_index(1).to_a
    # # => [{(1, 2, 3), 1}, {(4, 5, 6), 2}]
    # ```
    def each_row_with_index(offset = 0)
      RowIndexIterator(T, M, N, typeof(self)).new(self, offset)
    end

    # Iterator for enumerating through rows and their index in a matrix.
    private class RowIndexIterator(T, M, N, A)
      include Iterator(Tuple(CommonVector(T, N), Int32))

      @i = 0

      # Creates the iterator.
      #
      # Requires the source *matrix* and *offset* added to the index.
      def initialize(@matrix : A, @offset : Int32)
      end

      # Retrieves the next row and its index plus offset.
      def next
        i = @i
        return stop if i >= M

        row = @matrix.unsafe_fetch_row(i)
        @i += 1
        {row, i + @offset}
      end
    end

    # Returns an iterator that enumerates through each column of the matrix.
    #
    # Yields a vector with the elements from the current column.
    # The size of the vector is equal to the number of rows.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_column.to_a
    # # => [(1, 4), (2, 5), (3, 6)]
    # ```
    def each_column
      ColumnIterator(T, M, N, typeof(self)).new(self)
    end

    # Iterator for enumerating through columns in a matrix.
    private class ColumnIterator(T, M, N, A)
      include Iterator(CommonVector(T, M))

      @j = 0

      # Creates the iterator.
      #
      # Requires the source *matrix*.
      def initialize(@matrix : A)
      end

      # Retrieves the next column.
      def next
        return stop if @j >= N

        @matrix.unsafe_fetch_column(@j).tap { @j += 1 }
      end
    end

    # Returns an iterator that enumerates through each column of the matrix.
    #
    # Yields a vector with the elements from the current column and the column index.
    # The size of the vector is equal to the number of rows.
    # An *offset* can be specified, which is added to the yielded column index.
    # This does not affect the starting column.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_column_with_index(1).to_a
    # # => [{(1, 4), 1}, {(2, 5), 2}, {(3, 6), 3}]
    # ```
    def each_column_with_index(offset = 0)
      ColumnIndexIterator(T, M, N, typeof(self)).new(self, offset)
    end

    # Iterator for enumerating through columns and their index in a matrix.
    private class ColumnIndexIterator(T, M, N, A)
      include Iterator(Tuple(CommonVector(T, M), Int32))

      @j = 0

      # Creates the iterator.
      #
      # Requires the source *matrix* and *offset* added to the index.
      def initialize(@matrix : A, @offset : Int32)
      end

      # Retrieves the next column and its index plus offset.
      def next
        j = @j
        return stop if j >= N

        column = @matrix.unsafe_fetch_column(j)
        @j += 1
        {column, j + @offset}
      end
    end
  end
end
