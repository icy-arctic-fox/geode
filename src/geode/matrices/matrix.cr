require "./common"

module Geode
  # Generic matrix type.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # *M* and *N* are positive integers indicating the number of rows and columns respectively.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  struct Matrix(T, M, N)
    include CommonMatrix(T, M, N)

    # Storage for the matrix is placed on the heap.
    # This allows arbitrarily large matrices.
    # A pointer is used because it only takes 8 bytes (on 64-bit systems),
    # compared to 16 for a `Slice` and 24 for an `Array`.
    @elements : Pointer(T)

    # Constructs a matrix with existing elements.
    #
    # The type of the components is derived from the type of each argument.
    # The size of the vector is determined by the number of components.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # # => [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # ```
    macro [](*rows)
      {% m = rows.size %}
      {% n = rows.first.size %}
      {% raise "Rows in the matrix have different sizes" if rows.any? { |row| row.size != n } %}

      %rows = { {{rows.map(&.splat).splat}} }
      {{@type.name(generic_args: false)}}(typeof(%rows.first), {{m}}, {{n}}).new(%rows)
    end

    # Creates a new matrix by iterating through each element.
    #
    # Yields the indices (*i* and *j*) for the matrix element.
    # The block should return the value to use for the corresponding element.
    #
    # ```
    # Matrix(Int32, 3, 3).new { |i, j| i * 10 + j }
    # # => [[0, 1, 2], [10, 11, 12], [20, 21, 22]]
    # ```
    def initialize(& : Int32, Int32 -> T)
      i = 0
      j = 0

      @elements = Pointer(T).malloc(size) do
        value = yield i, j

        j += 1
        if j >= N
          j = 0
          i += 1
        end

        value
      end
    end

    # Creates a new matrix from nested collections.
    #
    # The size of *rows* must be equal to the type argument *M*.
    # Each row of elements in *rows* must have a size equal to the type argument *N*.
    #
    # ```
    # Matrix(Int32, 3, 2).new([[10, 20], [30, 40], [50, 60]])
    # # => [[10, 20], [30, 40], [50, 60]]
    # Matrix(Int32, 3, 2).new({{10, 20}, {30, 40}, {50, 60}})
    # # => [[10, 20], [30, 40], [50, 60]]
    # ```
    def initialize(rows : Indexable(Indexable(T)))
      raise IndexError.new("Rows does not match matrix size, got #{rows.size}, expected #{M}") if rows.size != M
      raise IndexError.new("Columns does not match matrix size, expected #{N}") if rows.any? { |row| row.size != N }

      initialize { |i, j| rows[i][j] }
    end

    # Creates a new matrix from a flat collection of elements.
    #
    # The size of *elements* must equal to *M* x *N*.
    # Items in *elements* are consumed in row-major order.
    #
    # ```
    # Matrix(Int32, 3, 2).new([1, 2, 3, 4, 5, 6])
    # # => [[1, 2], [3, 4], [5, 6]]
    # ```
    def initialize(elements : Indexable(T))
      raise IndexError.new("Elements must be #{size} in size") if elements.size != size

      @elements = Pointer(T).malloc(size) { |index| elements.unsafe_fetch(index) }
    end

    # Creates a matrix filled with zeroes.
    #
    # ```
    # Matrix(Int32, 2, 2).zero
    # # => [[0, 0], [0, 0]]
    # ```
    def self.zero
      new { T.zero }
    end

    # Creates an identity matrix.
    #
    # An identity matrix is a square matrix with ones along the diagonal and zeroes elsewhere.
    # Raises a compilation error if *M* and *N* are not the same (producing a square matrix).
    #
    # ```
    # Matrix(Int32, 3, 3).identity
    # # => [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    # ```
    def self.identity
      {% raise "Identity matrix must be a square matrix (M == N)" if M != N %}

      new do |i, j|
        i == j ? T.new(1) : T.zero
      end
    end

    # Returns a new matrix where elements are mapped by the given block.
    #
    # ```
    # matrix = Matrix[[1, 2], [3, 4], [5, 6]]
    # matrix.map { |e| e * 2 } # => [[2, 4], [6, 8], [10, 12]]
    # ```
    def map(& : T -> U) : CommonMatrix forall U
      index = 0
      {% begin %}
        {{@type.name(generic_args: false)}}(U, M, N).new do
          value = yield unsafe_fetch(index)
          index += 1
          value
        end
      {% end %}
    end

    # Retrieves the scalar value of the component at the given *index*,
    # without checking size boundaries.
    #
    # End-users should never invoke this method directly.
    # Instead, methods like `#[]` and `#[]?` should be used.
    #
    # This method should only be directly invoked if the index is certain to be in bounds.
    @[AlwaysInline]
    def unsafe_fetch(index : Int)
      @elements[index]
    end

    # Returns a slice that points to the elements in this matrix.
    @[AlwaysInline]
    def to_slice : Slice(T)
      @elements.to_slice(size)
    end

    # Returns a pointer to the data for this matrix.
    #
    # The elements are tightly packed and ordered consecutively in memory.
    @[AlwaysInline]
    def to_unsafe : Pointer(T)
      @elements
    end
  end
end
