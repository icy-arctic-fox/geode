require "./base"
require "./transforms3d"
require "./projections"

module Geode
  # Matrix with 4 rows and 1 column.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 4, 1 do
    def unsafe_fetch_row(i : Int) : Vector1(T)
      Vector1[unsafe_fetch(i)]
    end

    def unsafe_fetch_column(j : Int) : Vector4(T)
      Vector4[a, b, c, d]
    end
  end

  # Matrix with 4 rows and 2 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 4, 2 do
    def unsafe_fetch_row(i : Int) : Vector2(T)
      Vector2[unsafe_fetch(i, 0), unsafe_fetch(i, 1)]
    end

    def unsafe_fetch_column(j : Int) : Vector4(T)
      Vector4[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j), unsafe_fetch(3, j)]
    end
  end

  # Matrix with 4 rows and 3 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 4, 3 do
    def unsafe_fetch_row(i : Int) : Vector3(T)
      Vector3[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2)]
    end

    def unsafe_fetch_column(j : Int) : Vector4(T)
      Vector4[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j), unsafe_fetch(3, j)]
    end
  end

  # Matrix with 4 rows and 4 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 4, 4 do
    extend Matrix4x4Transforms3DConstructors(T)
    extend MatrixProjections(T)
    include Matrix4x4Transforms3D(T)

    def unsafe_fetch_row(i : Int) : Vector4(T)
      Vector4[unsafe_fetch(i, 0), unsafe_fetch(i, 1), unsafe_fetch(i, 2), unsafe_fetch(i, 3)]
    end

    def unsafe_fetch_column(j : Int) : Vector4(T)
      Vector4[unsafe_fetch(0, j), unsafe_fetch(1, j), unsafe_fetch(2, j), unsafe_fetch(3, j)]
    end

    def diagonal : Vector4(T)
      Vector4(T).new(a, f, k, p)
    end

    def determinant
      a * sub(0, 0).determinant -
        b * sub(0, 1).determinant +
        c * sub(0, 2).determinant -
        d * sub(0, 3).determinant
    end
  end

  # Short-hand for a 4x4 matrix.
  alias Matrix4 = Matrix4x4
end
