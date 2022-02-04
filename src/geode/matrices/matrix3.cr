require "./base"
require "./transforms2d"
require "./transforms3d"

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
    extend Matrix3x3Transforms2DConstructors(T)
    extend Matrix3x3Transforms3DConstructors(T)
    include Matrix3x3Transforms2D(T)
    include Matrix3x3Transforms3D(T)

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

    def inverse
      a2 = e * i - f * h
      b2 = -(d * i - f * g)
      c2 = d * h - e * g

      det = a * a2 + b * b2 + c * c2
      return if det.zero?

      d2 = -(b * i - c * h)
      e2 = a * i - c * g
      f2 = -(a * h - b * g)
      g2 = b * f - c * e
      h2 = -(a * f - c * d)
      i2 = a * e - b * d

      Matrix3x3.new(StaticArray[
        a2 / det, d2 / det, g2 / det,
        b2 / det, e2 / det, h2 / det,
        c2 / det, f2 / det, i2 / det,
      ])
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
