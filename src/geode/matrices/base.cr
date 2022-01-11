require "./common"
require "./square"

module Geode
  # Defines a matrix type with static rows and columns.
  private macro define_matrix(rows, columns)
    {% size = rows * columns %}
    {% type = "Matrix#{rows}x#{columns}".id %}
    struct {{type}}(T)
      include CommonMatrix(T, {{rows}}, {{columns}})
      {% if rows == columns %}include SquareMatrix(T, {{rows}}, {{columns}}){% end %}

      # Storage for the matrix is implemented with a static array.
      # Array elements are flattened and stored in row-major order.
      @array : StaticArray(T, {{size}})

      # Constructs a matrix with existing elements.
      #
      # The type of the components is derived from the type of each argument.
      # The size of *rows* must be {{rows}} and the size of each row must be {{columns}}.
      macro [](*rows)
        \{% m = rows.size %}
        \{% n = rows.first.size %}
        \{% raise "Row count doesn't match type (#{m} != {{rows}})" if m != {{rows}} %}
        \{% raise "Rows in the matrix have different sizes" if rows.any? { |row| row.size != n } %}

        \%rows = { \{{rows.map(&.splat).splat}} }
        \{{@type.name(generic_args: false)}}(typeof(\%rows.first)).new(\%rows)
      end

      # Copies contents from another matrix.
      def initialize(matrix : CommonMatrix(T, {{rows}}, {{columns}}))
        @array = uninitialized StaticArray(T, {{size}})
        @array.to_unsafe.copy_from(matrix.to_unsafe)
      end

      # Creates a new matrix by iterating through each element.
      #
      # Yields the indices (*i* and *j*) for the matrix element.
      # The block should return the value to use for the corresponding element.
      #
      # ```
      # {{type}}.new { |i, j| i * 10 + j }
      # ```
      def initialize(& : Int32, Int32 -> T)
        i = 0
        j = 0

        @array = StaticArray(T, {{size}}).new do
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
      # The size of *rows* must be {{rows}}.
      # Each row of elements in *rows* must have a size of {{columns}}.
      def initialize(rows : Indexable(Indexable(T)))
        raise IndexError.new("Rows does not match matrix size, got #{rows.size}, expected #{M}") if rows.size != M
        raise IndexError.new("Columns does not match matrix size, expected #{N}") if rows.any? { |row| row.size != N }

        initialize do |i, j|
          rows.unsafe_fetch(i).unsafe_fetch(j)
        end
      end

      # Creates a new matrix from a flat collection of elements.
      #
      # The size of *elements* must be equal to {{rows}} x {{columns}} ({{size}}).
      # Items in *elements* are consumed in row-major order.
      def initialize(elements : Indexable(T))
        raise IndexError.new("Elements must be #{size} in size") if elements.size != size

        @array = StaticArray(T, {{size}}).new { |index| elements.unsafe_fetch(index) }
      end

      # Creates a new matrix from its underlying elements.
      protected def initialize(@array : StaticArray(T, {{size}}))
      end

      # Creates a matrix filled with zeroes.
      def self.zero : self
        new { T.zero }
      end

      {% if rows == columns %}
        # Creates an identity matrix.
        #
        # An identity matrix is a square matrix with ones along the diagonal and zeroes elsewhere.
        def self.identity : self
          array = StaticArray(T, {{size}}).new(T.zero)
          {% index = 0 %}
          {% for i in 0...rows %}
            array.unsafe_put({{index}}, T.new(1))
            {% index += columns + 1 %}
          {% end %}
          new(array)
        end
      {% end %}

      # Returns a new matrix with elements mapped by the given block.
      def map(& : T -> U) : {{type}} forall U
        index = 0
        {{type}}(U).new do
          value = yield unsafe_fetch(index)
          index += 1
          value
        end
      end

      # Returns a new matrix that is transposed from this one.
      def transpose : Matrix{{columns}}x{{rows}}(T)
        Matrix{{columns}}x{{rows}}(T).new do |i, j|
          unsafe_fetch(j, i)
        end
      end

      {% if rows > 1 && columns > 1 %}
        # Returns a smaller matrix by removing a row and column.
        #
        # The row indicated by *i* and the column indicated by *j* are removed in the resulting matrix.
        def sub(i : Int, j : Int) : Matrix{{columns - 1}}x{{rows - 1}}(T)
          array = uninitialized StaticArray(T, {{(columns - 1) * (rows - 1)}})
          index = 0
          each_with_indices do |e, si, sj|
            next if si == i || sj == j

            array.unsafe_put(index, e)
            index += 1
          end

          Matrix{{columns - 1}}x{{rows - 1}}(T).new(array)
        end
      {% end %}

      # Multiplies this matrix by another.
      #
      # The other matrix's row count (*M*) must be equal to this matrix's column count (*N*).
      # Produces a new matrix with the row count from this matrix and the column count from *other*.
      # Matrices can be of any size and type as long as this condition is met.
      def *(other : CommonMatrix(U, {{columns}}, P)) : Matrix forall U, P
        Matrix(typeof(first * other.first), {{rows}}, P).new do |i, j|
          row = unsafe_fetch_row(i)
          column = other.unsafe_fetch_column(j)
          row.dot(column)
        end
      end

      # Multiplies this matrix by another.
      #
      # The other matrix's row count (*M*) must be equal to this matrix's column count (*N*).
      # Produces a new matrix with the row count from this matrix and the column count from *other*.
      # Matrices can be of any size and type as long as this condition is met.
      #
      # Values will wrap instead of overflowing and raising an error.
      def &*(other : CommonMatrix(U, {{columns}}, P)) : Matrix forall U, P
        Matrix(typeof(first &* other.first), {{rows}}, P).new do |i, j|
          row = unsafe_fetch_row(i)
          column = other.unsafe_fetch_column(j)
          row.dot!(column)
        end
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
        @array.unsafe_fetch(index)
      end

      # Returns a slice that points to the elements in this matrix.
      #
      # NOTE: The returned slice is only valid for the caller's scope and sub-calls.
      #   The slice points to memory on the stack, it will be invalid after the caller returns.
      @[AlwaysInline]
      def to_slice : Slice(T)
        @array.to_slice
      end

      # Returns a pointer to the data for this matrix.
      #
      # The elements are tightly packed and ordered consecutively in memory.
      #
      # NOTE: The returned pointer is only valid for the caller's scope and sub-calls.
      #   The pointer refers to memory on the stack, it will be invalid after the caller returns.
      @[AlwaysInline]
      def to_unsafe : Pointer(T)
        @array.to_unsafe
      end

      # Ensures that another matrix and this one have the same size at compile-time.
      #
      # The *rows* and *columns* arguments should be the type arguments from the other matrix type.
      #
      # ```
      # def something(other : CommonMatrix(T, M, N))
      #   same_size!(M, N)
      #   # ...
      # end
      # ```
      private macro same_size!(rows, columns)
        \\{% raise "Matrices must have the same dimensions for this operation (#{\{{rows}}}x#{\{{columns}}} != {{rows}}x{{columns}})" if \{{rows}} != {{rows}} || \{{columns}} != {{columns}} %}
      end

      {% letters = %i[a b c d e f g h i j k l m n o p q r s t u v w x y z] %}
      {% for m in 0...rows %}
        {% for n in 0...columns %}
          # Retrieves the element at ({{m}}, {{n}})
          @[AlwaysInline]
          def {{letters[m * n].id}} : T
            unsafe_fetch({{m * n}})
          end
        {% end %}
      {% end %}

      {{yield}}
    end
  end
end
