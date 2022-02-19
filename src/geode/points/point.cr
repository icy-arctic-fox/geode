module Geode
  # Base type for all point with a specific dimensionality.
  #
  # *T* is the scalar type.
  # *N* is a positive integer indicating the number of dimensions.
  abstract struct Point(T, N)
    include Indexable(T)

    # Storage for the point is implemented with a static array.
    @array : StaticArray(T, N)

    # Constructs the vector with pre-existing values.
    def initialize(@array : StaticArray(T, N))
    end

    # Constructs the point by yielding for each coordinate.
    #
    # The value of each coordinate should be returned from the block.
    # The block will be given the index of each coordinate as an argument.
    #
    # ```
    # Point3(Int32).new { |i| i * 5 } # => (0, 5, 10)
    # ```
    def initialize(& : Int32 -> T)
      @array = StaticArray(T, N).new { |i| yield i }
    end

    # Constructs a point referencing the origin.
    #
    # Each coordinate will have a scalar value equal to the type's zero value.
    # This is done by calling `T.zero` for each coordinate.
    # The type *T* must have a `.zero` class method.
    #
    # ```
    # Point3(Float32).zero # => (0.0, 0.0, 0.0)
    # ```
    def self.zero : self
      new { T.zero }
    end

    # :ditto:
    @[AlwaysInline]
    def self.origin : self
      zero
    end

    # Returns the dimensionality of this point.
    def size
      N
    end

    # Returns a new point where coordinates are mapped by the given block.
    #
    # ```
    # point = Point3.new(1, 2, 3)
    # point.map { |v| v * 2 } # => (2, 4, 6)
    # ```
    def map(& : T -> U) : Point(U, N) forall U
      {% begin %}
        {{@type.name(generic_args: false)}}(U).new { |i| yield unsafe_fetch(i) }
      {% end %}
    end

    # Like `#map`, but the block gets the coordinate and its index as arguments.
    #
    # Accepts an optional *offset* parameter, which to start the index at.
    #
    # ```
    # point = Point3[1, 2, 3]
    # point.map_with_index { |v, i| v * i }    # => (0, 2, 6)
    # point.map_with_index(3) { |v, i| v + i } # => (4, 6, 8)
    # ```
    def map_with_index(offset = 0, & : T, Int32 -> U) : Point(U, N) forall U
      i = offset
      map do |v|
        u = yield v, i
        i += 1
        u
      end
    end

    # Checks if this point is located at the origin.
    #
    # Returns true if all coordinates of this point are zero.
    #
    # See: `#near_zero?`
    #
    # ```
    # Point3[0, 0, 0].zero? # => true
    # Point3[1, 0, 2].zero? # => false
    # ```
    def zero?
      all? &.zero?
    end

    # Checks if this point is located near the origin.
    #
    # Returns true if all coordinates of this point are close to zero.
    #
    # ```
    # Point3[0.0, 0.01, 0.001].near_zero?(0.01) # => true
    # Point3[0.1, 0.0, 0.01].near_zero?(0.01)   # => false
    # ```
    def near_zero?(tolerance)
      all? { |v| v.abs <= tolerance }
    end

    # Retrieves the scalar value of the coordinate at the given *index*,
    # without checking size boundaries.
    #
    # End-users should never invoke this method directly.
    # Instead, methods like `#[]` and `#[]?` should be used.
    #
    # This method should only be directly invoked if the index is certain to be in bounds.
    @[AlwaysInline]
    def unsafe_fetch(index : Int)
      @array.unsafe_fetch(index)
    end

    # Converts this point to a vector.
    #
    # ```
    # point = Point3[1, 2, 3]
    # point.to_vector # => (1, 2, 3)
    # ```
    abstract def to_vector

    # Produces a string representation of the point.
    #
    # The format is: `(x, y, z)`
    # but with the corresponding number of coordinates.
    def to_s(io : IO) : Nil
      io << '('
      @array.join(io, ", ")
      io << ')'
    end

    # Returns a slice that points to the coordinates in this point.
    #
    # NOTE: The returned slice is only valid for the caller's scope and sub-calls.
    #   The slice points to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_slice : Slice(T)
      @array.to_slice
    end

    # Returns a pointer to the data for this point.
    #
    # The coordinates are tightly packed and ordered consecutively in memory.
    #
    # NOTE: The returned pointer is only valid for the caller's scope and sub-calls.
    #   The pointer refers to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_unsafe : Pointer(T)
      @array.to_unsafe
    end

    # Checks if coordinates between two points are equal.
    #
    # Compares this point coordinate-wise to another.
    # Returns true if all coordinates are equal, false otherwise.
    #
    # ```
    # Point3[1, 2, 3] == Point3[1, 2, 3] # => true
    # Point3[1, 2, 3] == Point3[3, 2, 1] # => false
    # ```
    def ==(other : Point)
      return false if size != other.size

      each_with_index do |v, i|
        return false if v != other.unsafe_fetch(i)
      end
      true
    end
  end
end
