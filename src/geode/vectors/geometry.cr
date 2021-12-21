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

    # Orients a vector to point in the same direction as another.
    #
    # The *surface* is a vector to orient with.
    def forward(surface : CommonVector(T, N)) : CommonVector forall T
      dot(surface) < T.zero ? -self : self
    end

    # Computes a reflected vector on a surface.
    #
    # The *surface* is a normal vector for the surface to reflect against.
    #
    # ```
    # Vector[-1, 1].reflect(Vector[0, 1]) # => (1, 1)
    # ```
    def reflect(surface : CommonVector(T, N)) : CommonVector forall T
      norm = surface.normalize
      self - norm * dot(norm) * T.new(2)
    end

    # Computes a refracted vector through a surface.
    #
    # The *surface* is a normal vector for the surface to travel through.
    # *eta* is the ratio of refractive indices.
    # Returns a zero vector for total internal reflection.
    #
    # ```
    # Vector[-1, 1].refract(Vector[0, 1], 1.333) # => (-1.333, -1.0)
    # ```
    def refract(surface : CommonVector(T, N), eta : Number) : CommonVector forall T
      norm = surface.normalize
      dot = dot(norm)
      k = T.new(1) - eta.abs2 * (T.new(1) - dot.abs2)
      return self.class.zero if k < 0

      self * eta - (norm * (eta * dot + Math.sqrt(k)))
    end
  end
end