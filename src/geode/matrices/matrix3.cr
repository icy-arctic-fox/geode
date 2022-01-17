require "./base"
require "./transforms3"

module Geode
  # Matrix with 3 rows and 1 column.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 3, 1 do
    def unsafe_fetch_row(i : Int) : Vector1(T)
      Vector1[unsafe_fetch(i)]
    end

    def unsafe_fetch_column(j : Int) : Vector3(T)
      Vector3[a, b, c]
    end
  end

  # Matrix with 3 rows and 2 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 3, 2 do
    def unsafe_fetch_row(i : Int) : Vector2(T)
      Vector2[unsafe_fetch(i, 0), unsafe_fetch(i, 1)]
    end

    def unsafe_fetch_column(j : Int) : Vector3(T)
      Vector3[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j)]
    end
  end

  # Matrix with 3 rows and 3 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 3, 3 do
    extend MatrixTransforms3(T)

    def unsafe_fetch_row(i : Int) : Vector3(T)
      Vector3[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2)]
    end

    def unsafe_fetch_column(j : Int) : Vector3(T)
      Vector3[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j)]
    end

    def diagonal : Vector3(T)
      Vector3(T).new(a, e, i)
    end

    def determinant
      a * e * i + b * f * g + c * d * h - c * e * g - b * d * i - a * f * h
    end
  end

  # Matrix with 3 rows and 4 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 3, 4 do
    def unsafe_fetch_row(i : Int) : Vector4(T)
      Vector4[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2), unsafe_fetch(i, 3)]
    end

    def unsafe_fetch_column(j : Int) : Vector3(T)
      Vector3[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j)]
    end
  end

  # Short-hand for a 3x3 matrix.
  alias Matrix3 = Matrix3x3
end
