module Geode
  # Transformation that can be performed in two-dimensions with matrices.
  #
  # Multiplying a 2D object by the matrices produced by these methods will apply the operation to the object.
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
  module MatrixTransforms2(T)
    # Creates a 2D rotation matrix.
    #
    # Multiplying a 2D object by this matrix will rotate it the specified amount.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector2[1, 1].normalize
    # matrix = Matrix2(Float64).rotate(45.degrees)
    # vector * matrix # => (0.0, 1.0)
    # ```
    def rotate(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, sin,
        -sin, cos,
      ])
    end

    # Creates a 2D 90-degree rotation matrix.
    #
    # Multiplying a 2D object by this matrix will rotate it 90 degrees.
    #
    # ```
    # vector = Vector2[1, 1]
    # matrix = Matrix2(Int32).rotate90
    # vector * matrix # => (-1, 1)
    # ```
    def rotate90 : self
      new(StaticArray[
        T.zero, T.multiplicative_identity,
        -T.multiplicative_identity, T.zero,
      ])
    end

    # Creates a 2D 180-degree rotation matrix.
    #
    # Multiplying a 2D object by this matrix will rotate it 180 degrees.
    #
    # ```
    # vector = Vector2[1, 1]
    # matrix = Matrix2(Int32).rotate180
    # vector * matrix # => (-1, -1)
    # ```
    def rotate180 : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero,
        T.zero, -T.multiplicative_identity,
      ])
    end

    # Creates a 2D 270-degree rotation matrix.
    #
    # Multiplying a 2D object by this matrix will rotate it 270 degrees.
    #
    # ```
    # vector = Vector2[1, 1]
    # matrix = Matrix2(Int32).rotate270
    # vector * matrix # => (1, 1)
    # ```
    #
    # See: `#reflect_xy`
    def rotate270 : self
      new(StaticArray[
        T.zero, -T.multiplicative_identity,
        T.multiplicative_identity, T.zero,
      ])
    end

    # Creates a 2D scaling matrix.
    #
    # Uniformly scales an object.
    # Multiplying a 2D object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector2[2, 3]
    # matrix = Matrix2(Int32).scale(2)
    # vector * matrix # => (4, 6)
    # ```
    def scale(amount : T) : self
      new(StaticArray[
        amount, T.zero,
        T.zero, amount,
      ])
    end

    # Creates a 2D scaling matrix.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying a 2D object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector2[2, 3]
    # matrix = Matrix2(Float64).scale(1.5, 2)
    # vector * matrix # => (3.0, 6.0)
    # ```
    def scale(x : T, y : T) : self
      new(StaticArray[
        x, T.zero,
        T.zero, y,
      ])
    end

    # Creates a 2D reflecting matrix.
    #
    # Multiplying a 2D object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector2[5, 1]
    # matrix = Matrix2(Int32).reflect_x
    # vector * matrix # => (-5, 1)
    # ```
    def reflect_x : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero,
        T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D reflective matrix.
    #
    # Multiplying a 2D object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector2[5, 1]
    # matrix = Matrix2(Int32).reflect_y
    # vector * matrix # => (5, -1)
    # ```
    def reflect_y : self
      new(StaticArray[
        T.multiplicative_identity, T.zero,
        T.zero, -T.multiplicative_identity,
      ])
    end

    # Creates a 2D reflective matrix.
    #
    # Multiplying a 2D object by this matrix will reflect it along the x and y-axis.
    # This has the same effect as rotating 180 degrees.
    #
    # ```
    # vector = Vector2[5, 1]
    # matrix = Matrix2(Int32).reflect_xy
    # vector * matrix # => (-5, -1)
    # ```
    #
    # See: `#rotate270`
    def reflect_xy : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero,
        T.zero, -T.multiplicative_identity,
      ])
    end

    # Creates a 2D shearing matrix.
    #
    # Multiplying a 2D object by this matrix will shear it along the x-axis.
    #
    # ```
    # vector = Vector2[2, 3]
    # matrix = Matrix2(Int32).shear_x(2)
    # vector * matrix # => (8, 3)
    # ```
    def shear_x(amount : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero,
        amount, T.multiplicative_identity,
      ])
    end

    # Creates a 2D shearing matrix.
    #
    # Multiplying a 2D object by this matrix will shear it along the y-axis.
    #
    # ```
    # vector = Vector2[2, 3]
    # matrix = Matrix2(Int32).shear_y(2)
    # vector * matrix # => (2, 7)
    # ```
    def shear_y(amount : T) : self
      new(StaticArray[
        T.multiplicative_identity, amount,
        T.zero, T.multiplicative_identity,
      ])
    end
  end
end
