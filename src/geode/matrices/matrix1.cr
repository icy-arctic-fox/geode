require "./base"

module Geode
  # Matrix with 1 row and 1 column.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 1 do
    def determinant
      a
    end
  end

  # Matrix with 1 row and 2 columns.
  # Provides a rectangular array of scalars of the same type.
  #
  # *T* is the scalar type.
  # Indices *i* and *j* refer to the zero-based row and column index respectively.
  # Unless noted otherwise, all operations are in row-major order.
  define_matrix 1, 2

  # Short-hand for a 1x1 matrix.
  alias Matrix1 = Matrix1x1
end
