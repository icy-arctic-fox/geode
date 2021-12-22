module Geode
  # Common operations for vectors.
  #
  # Intended to be used as a mix-in on vector types.
  # *N* is the number of components in the vector.
  module VectorOperations(N)
    # Returns a vector containing the absolute value of each component.
    #
    # ```
    # Vector[-5, 42, -20].abs # => (5, 42, 20)
    # ```
    def abs : self
      map &.abs
    end

    # Returns a vector containing the square of each component.
    #
    # ```
    # Vector[-5, 3, -2].abs2 # => (25, 9, 4)
    # ```
    def abs2 : self
      map &.abs2
    end

    # Returns a vector with each component rounded.
    #
    # See `Number#round` for details.
    #
    # ```
    # Vector[1.2, -5.7, 3.0].round # => (1.0, -6.0, 3.0)
    # ```
    def round(mode : Number::RoundingMode = :ties_even) : self
      map &.round(mode)
    end

    # Returns a vector with each component rounded.
    #
    # See `Number#round` for details.
    #
    # ```
    # Vector[1.25, -5.77, 3.01].round(1) # => (1.3, -5.8, 3.0)
    # ```
    def round(digits : Number, base = 10, *, mode : Number::RoundingMode = :ties_even) : self
      map &.round(digits, base, mode: mode)
    end

    # Returns a vector with components equal to their original sign.
    #
    # 1 is used for positive values, -1 for negative values, and 0 for zero.
    #
    # ```
    # Vector[5, 0, -5] # => (1, 0, -1)
    # ```
    def sign : self
      map &.sign
    end

    # Returns a vector with components rounded up to the nearest integer.
    #
    # ```
    # Vector[1.2, -5.7, 3.0] # => (2.0, -5.0, 3.0)
    # ```
    def ceil : self
      map &.ceil
    end

    # Returns a vector with components rounded down to the nearest integer.
    #
    # ```
    # Vector[1.2, -5.7, 3.0] # => (1.0, -6.0, 3.0)
    # ```
    def floor : self
      map &.floor
    end

    # Returns a vector with the fraction from each component.
    #
    # This is effectively equal to:
    #
    # ```text
    # fraction(v) = v - floor(v)
    # ```
    #
    # ```
    # Vector[1.2, -5.7, 3.0] # => (0.2, 0.3, 0.0)
    # ```
    def fraction : self
      self - floor
    end

    # Returns a vector restricted to the minimum and maximum values from other vectors.
    #
    # ```
    # min = Vector[-1, -1, -1]
    # max = Vector[1, 1, 1]
    # Vector[5, -2, 0].clamp(min, max) # => (1, -1, 0)
    # ```
    def clamp(min : CommonVector(T, N), max : CommonVector(T, N)) forall T
      map_with_index do |v, i|
        lower = min.unsafe_fetch(i)
        upper = max.unsafe_fetch(i)
        v.clamp(lower, upper)
      end
    end

    # Returns a vector restricted to the range from other vectors.
    #
    # ```
    # min = Vector[-1, -1, -1]
    # max = Vector[1, 1, 1]
    # Vector[5, -2, 0].clamp(min..max) # => (1, -1, 0)
    # ```
    def clamp(range : Range(CommonVector(T, N), CommonVector(T, N))) forall T
      raise ArgumentError.new("Can't clamp an exclusive range") if !range.end.nil? && range.exclusive?
      clamp(range.begin, range.end)
    end

    # Returns a vector restricted to min and max values.
    #
    # *min* and *max* should be scalar values.
    # Each component of the vector is clipped to these same values.
    #
    # ```
    # Vector[5, -2, 0].clamp(-1, 1) # => (1, -1, 0)
    # ```
    def clamp(min, max)
      map &.clamp(min, max)
    end

    # Returns a vector restricted to a range.
    #
    # The range should consist of scalar values.
    # Each component of the vector is clipped to the same range.
    #
    # ```
    # Vector[5, -2, 0].clamp(-1..1) # => (1, -1, 0)
    # ```
    def clamp(range)
      raise ArgumentError.new("Can't clamp an exclusive range") if !range.end.nil? && range.exclusive?
      clamp(range.begin, range.end)
    end

    # Returns a new vector where each component is 0 if it's less than the edge value, or 1 if it's greater.
    #
    # ```
    # Vector[1, 2, 3].edge(2) # => (0, 1, 1)
    # ```
    def edge(edge : T) : self forall T
      map { |v| v < edge ? T.zero : T.new(1) }
    end

    # Returns a new vector where each component is 0 if it's less than the corresponding edge value, or 1 if it's greater.
    #
    # ```
    # Vector[1, 2, 3].edge(Vector[3, 2, 1]) # => (0, 1, 1)
    # ```
    def edge(edge : CommonVector(T, N)) : self forall T
      zip_map(edge) { |v, e| v < e ? T.zero : T.new(1) }
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

    # Calculates the linear interpolation between two vectors.
    #
    # *t* is a value from 0 to 1, where 0 represents this vector and 1 represents *other*.
    # Any value between 0 and 1 will result in a proportional amount of this vector and *other*.
    #
    # This method uses the precise calculation
    # that does not suffer precision loss from high exponential differences.
    def lerp(other : CommonVector(T, N), t : Number) : CommonVector forall T
      Geode.lerp(self, other, t)
    end

    # Returns a negated vector.
    #
    # ```
    # -Vector[5, -2, 0] # => (-5, 2, 0)
    # ```
    def - : self
      map &.-
    end

    # Adds two vectors together.
    #
    # ```
    # Vector[5, -2, 0] + Vector[2, -1, 4] # => (7, -3, 4)
    # ```
    def +(other : CommonVector(T, N)) forall T
      zip_map(other) { |a, b| a + b }
    end

    # Subtracts another vector from this one.
    #
    # ```
    # Vector[5, -2, 0] - Vector[2, -1, 4] # => (3, -1, -4)
    # ```
    def -(other : CommonVector(T, N)) forall T
      zip_map(other) { |a, b| a - b }
    end

    # Scales each component by the specified amount.
    #
    # ```
    # Vector[5, -2, 0] * 3 # => (15, -6, 0)
    # ```
    def *(scalar)
      map &.*(scalar)
    end

    # Scales each component by the specified amount.
    #
    # ```
    # Vector[16, -2, 0] / 4 # => (4, -0.5, 0)
    # ```
    def /(scalar)
      map &./(scalar)
    end

    # Scales each component by the specified amount.
    #
    # Uses integer division.
    #
    # ```
    # Vector[7, -3, 0] // 3 # => (2, -1, 0)
    # ```
    def //(scalar)
      map &.//(scalar)
    end
  end
end
