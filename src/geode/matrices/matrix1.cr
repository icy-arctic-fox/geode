require "./base"

module Geode
  # Matrix with 1 row and 1 column.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 1 do
    def unsafe_fetch_row(i : Int) : Vector1(T)
      Vector1[a]
    end

    def unsafe_fetch_column(j : Int) : Vector1(T)
      Vector1[a]
    end

    def diagonal
      Vector1[a]
    end

    def determinant
      a
    end

    def inverse
      return if a.zero?

      inv = T.multiplicative_identity / a
      Matrix1x1[[inv]]
    end
  end

  # Matrix with 1 row and 2 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 2 do
    def unsafe_fetch_row(i : Int) : Vector2(T)
      Vector2[a, b]
    end

    def unsafe_fetch_column(j : Int) : Vector1(T)
      Vector1[unsafe_fetch(j)]
    end
  end

  # Matrix with 1 row and 3 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 3 do
    def unsafe_fetch_row(i : Int) : Vector3(T)
      Vector3[a, b, c]
    end

    def unsafe_fetch_column(j : Int) : Vector1(T)
      Vector1[unsafe_fetch(j)]
    end
  end

  # Matrix with 1 row and 4 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 4 do
    def unsafe_fetch_row(i : Int) : Vector4(T)
      Vector4[a, b, c, d]
    end

    def unsafe_fetch_column(j : Int) : Vector1(T)
      Vector1[unsafe_fetch(j)]
    end
  end

  # Short-hand for a 1x1 matrix.
  alias Matrix1 = Matrix1x1
end
