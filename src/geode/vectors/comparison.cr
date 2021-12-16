module Geode
  # Comparison operations for vectors.
  #
  # Intended to be used as a mix-in on vector types.
  # *N* is the number of components in the vector.
  module VectorComparison(N)
    # Compares components of this vector to another.
    #
    # Returns a bool vector.
    # Each component of the resulting vector is an integer.
    # The value will be:
    # - -1 if the component from this vector is less than the corresponding component from *other*.
    # - 0 if the component from this vector is equal to the corresponding component from *other*.
    # - 1 if the component from this vector is greater than the corresponding component from *other*.
    # - nil if the components can't be compared.
    #
    # ```
    # Vector[1, 2, 3].compare(Vector[3, 2, 1]) # => (-1, 0, 1)
    # ```
    def compare(other : CommonVector(T, N)) : CommonVector(Int32, N) forall T
      zip_map(other) { |a, b| a <=> b }
    end

    # Checks if components between two vectors are equal.
    #
    # Compares this vector component-wise to another.
    # Returns a bool vector.
    # Components of the resulting vector are true
    # if the corresponding vector components were equal.
    #
    # ```
    # Vector[1, 2, 3].eq?(Vector[3, 2, 1]) # => (false, true, false)
    # ```
    def eq?(other : CommonVector(T, N)) : CommonVector(Bool, N) forall T
      zip_map(other) { |a, b| a == b }
    end

    # Checks if components of this vector are less than those from another vector.
    #
    # Compares this vector component-wise to another.
    # Returns a bool vector.
    # Components of the resulting vector are true
    # if the corresponding component from this vector is less than the component from *other*.
    #
    # ```
    # Vector[1, 2, 3].lt?(Vector[3, 2, 1]) # => (true, false, false)
    # ```
    def lt?(other : CommonVector(T, N)) : CommonVector(Bool, N) forall T
      zip_map(other) { |a, b| a < b }
    end

    # Checks if components of this vector are less than or equal to those from another vector.
    #
    # Compares this vector component-wise to another.
    # Returns a bool vector.
    # Components of the resulting vector are true
    # if the corresponding component from this vector is less than or equal to the component from *other*.
    #
    # ```
    # Vector[1, 2, 3].le?(Vector[3, 2, 1]) # => (true, true, false)
    # ```
    def le?(other : CommonVector(T, N)) : CommonVector(Bool, N) forall T
      zip_map(other) { |a, b| a <= b }
    end

    # Checks if components of this vector are greater than those from another vector.
    #
    # Compares this vector component-wise to another.
    # Returns a bool vector.
    # Components of the resulting vector are true
    # if the corresponding component from this vector is greater than the component from *other*.
    #
    # ```
    # Vector[1, 2, 3].gt?(Vector[3, 2, 1]) # => (false, false, true)
    # ```
    def gt?(other : CommonVector(T, N)) : CommonVector(Bool, N) forall T
      zip_map(other) { |a, b| a > b }
    end

    # Checks if components of this vector are greater than or equal to those from another vector.
    #
    # Compares this vector component-wise to another.
    # Returns a bool vector.
    # Components of the resulting vector are true
    # if the corresponding component from this vector is greater than or equal to the component from *other*.
    #
    # ```
    # Vector[1, 2, 3].ge?(Vector[3, 2, 1]) # => (false, true, true)
    # ```
    def ge?(other : CommonVector(T, N)) : CommonVector(Bool, N) forall T
      zip_map(other) { |a, b| a >= b }
    end

    # Checks if this is a zero-vector.
    #
    # Returns true if all components of the vector are zero.
    #
    # See: `#near_zero?`
    #
    # ```
    # Vector[0, 0, 0].zero? # => true
    # Vector[1, 0, 2].zero? # => false
    # ```
    def zero?
      all? &.zero?
    end

    # Checks if this is close to a zero-vector.
    #
    # Returns true if all components of the vector are close to zero.
    #
    # ```
    # Vector[0.0, 0.01, 0.001].near_zero?(0.01) # => true
    # Vector[0.1, 0.0, 0.01].near_zero?(0.01)   # => false
    # ```
    def near_zero?(tolerance)
      all? { |v| v.abs <= tolerance }
    end
  end
end
