module Geode
  # Transformation that can be performed in four-dimensions with matrices.
  #
  # Multiplying a 4D object by the matrices produced by these methods will apply the operation to the object.
  # The matrix must be on the right-hand-side of the multiplication operation.
  #
  # ```
  # object * matrix
  # ```
  #
  # Matrix multiplication is not commutative, therefore the ordering matters.
  # If it's desired to have the matrix on the left-hand-side, transpose it before multiplying.
  #
  # ```
  # matrix.transpose * object
  # ```
  #
  # To combine multiple operations, multiply the matrices from these methods together.
  module MatrixTransforms4(T)
    # Creates a 3D transform matrix.
    #
    # ```
    # vector = Vector4[3, 5, 7, 1]
    # matrix = Matrix3(Int32).translate(3, 2, 1)
    # vector * matrix # => (6, 7, 8, 1)
    # ```
    def translate(x : T, y : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        x, y, z, T.multiplicative_identity,
      ])
    end
  end
end
