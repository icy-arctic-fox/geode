require "./base"
require "./transforms2"

module Geode
  # Matrix with 2 rows and 1 column.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 2, 1 do
    def unsafe_fetch_row(i : Int) : Vector1(T)
      Vector1[unsafe_fetch(i)]
    end

    def unsafe_fetch_column(j : Int) : Vector2(T)
      Vector2[a, b]
    end
  end

  # Matrix with 2 rows and 2 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 2, 2 do
    extend MatrixTransformConstructors2(T)

    def unsafe_fetch_row(i : Int) : Vector2(T)
      Vector2[unsafe_fetch(i, 0), unsafe_fetch(i, 1)]
    end

    def unsafe_fetch_column(j : Int) : Vector2(T)
      Vector2[unsafe_fetch(0, j), unsafe_fetch(1, j)]
    end

    def diagonal : Vector2(T)
      Vector2(T).new(a, d)
    end

    def determinant
      a * d - b * c
    end

    def inverse
      det = determinant
      return if det.zero?

      Matrix2x2.new(StaticArray[
        d / det, -b / det,
        -c / det, a / det,
      ])
    end
  end

  # Matrix with 2 rows and 3 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 2, 3 do
    def unsafe_fetch_row(i : Int) : Vector3(T)
      Vector3[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2)]
    end

    def unsafe_fetch_column(j : Int) : Vector2(T)
      Vector2[unsafe_fetch(0, j), unsafe_fetch(1, j)]
    end
  end

  # Matrix with 2 rows and 4 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 2, 4 do
    def unsafe_fetch_row(i : Int) : Vector4(T)
      Vector4[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2), unsafe_fetch(i, 3)]
    end

    def unsafe_fetch_column(j : Int) : Vector2(T)
      Vector2[unsafe_fetch(0, j), unsafe_fetch(1, j)]
    end
  end

  # Short-hand for a 2x2 matrix.
  alias Matrix2 = Matrix2x2
end
