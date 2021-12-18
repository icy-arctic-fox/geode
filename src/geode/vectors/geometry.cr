module Geode
  # Geometric methods for vectors.
  #
  # Intended to be used as a mix-in on vector types.
  # *N* is the number of components in the vector.
  module VectorGeometry(N)
    # Computes the magnitude (length) of this vector.
    #
    # ```
    # Vector[3, 4].mag # => 5
    # ```
    def mag
      Math.sqrt(mag2)
    end

    # Computes the magnitude (length) squared of this vector.
    #
    # This method does not perform a square-root operation,
    # making it faster than `#mag` if the square-root isn't needed.
    #
    # ```
    # Vector[3, 4].mag2 # => 25
    # ```
    def mag2
      sum &.abs2
    end

    # Computes the magnitude (length) of this vector.
    #
    # Same as `#mag`.
    #
    # ```
    # Vector[3, 4].length # => 5
    # ```
    @[AlwaysInline]
    def length
      mag
    end

    # Returns a unit vector.
    #
    # Scales the components of the vector equally so that the magnitude (length) is one.
    #
    # ```
    # Vector[1, 0, -1].normalize.mag # => 1.0
    # ```
    def normalize : CommonVector
      mag = self.mag
      map &./(mag)
    end

    # Returns a vector with the magnitude specified.
    #
    # Scales the components of the vector equally.
    #
    # ```
    # Vector[1, 0, -1].scale_to(2).mag # => 2.0
    # ```
    def scale_to(length) : CommonVector
      scale = length / mag
      map &.*(scale)
    end

    # Computes the dot-product of this vector and another.
    #
    # ```
    # Vector[2, 5, 7].dot(Vector[1, 0, -5]) # => -33
    # ```
    def dot(other : CommonVector(T, N)) forall T
      sum = T.zero
      each_with_index do |v, i|
        sum += v * other.unsafe_fetch(i)
      end
      sum
    end

    # Returns a vector with each component scaled by the corresponding component value.
    #
    # ```
    # Vector[1, 0, -1].scale(Vector[2, 3, 5]) # => (2, 0, -5)
    # ```
    def scale(vector : CommonVector(T, N)) : CommonVector forall T
      zip_map(vector) { |a, b| a * b }
    end

    # Scales each component by the specified amount.
    #
    # ```
    # Vector[5, -2, 0].scale(3) # => (15, -6, 0)
    # ```
    def scale(amount) : CommonVector
      map &.*(amount)
    end
  end
end
