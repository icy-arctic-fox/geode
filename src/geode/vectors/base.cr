require "./common"

module Geode
  # Base type for all vectors with a specific dimensionality.
  #
  # *T* is the scalar type.
  # *N* is a positive integer indicating the number of components.
  abstract struct VectorBase(T, N)
    include CommonVector(T, N)

    # Storage for the vector is implemented with a static array.
    @array : StaticArray(T, N)

    # Constructs the vector with pre-existing values.
    def initialize(@array : StaticArray(T, N))
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, N))
      @array = StaticArray(T, N).new { |i| other.unsafe_fetch(i) }
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector3(Int32).new { |i| i * 5 } # => (0, 5, 10)
    # ```
    def initialize(& : Int32 -> T)
      @array = StaticArray(T, N).new { |i| yield i }
    end

    # Constructs a zero-vector.
    #
    # Each component will have a scalar value equal to the type's'zero value.
    # This is done by calling `T.zero` for each component.
    # The type *T* must have a class method
    #
    # ```
    # Vector3(Float32).zero # => (0.0, 0.0, 0.0)
    # ```
    def self.zero : self
      array = StaticArray(T, N).new { T.zero }
      new(array)
    end

    # Returns a new vector where components are mapped by the given block.
    #
    # ```
    # vector = Vector3.new(1, 2, 3)
    # vector.map { |v| v * 2 } # => (2, 4, 6)
    # ```
    def map(& : T -> U) : CommonVector forall U
      array = StaticArray(U, N).new { |i| yield unsafe_fetch(i) }
      {{@type.name(generic_args: false)}}.new(array)
    end

    # Retrieves the scalar value of the component at the given *index*,
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

    # Returns a slice that points to the components in this vector.
    #
    # NOTE: The returned slice is only valid for the caller's scope and sub-calls.
    #   The slice points to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_slice : Slice(T)
      @array.to_slice
    end

    # Returns a pointer to the data for this vector.
    #
    # The components are tightly packed and ordered consecutively in memory.
    #
    # NOTE: The returned pointer is only valid for the caller's scope and sub-calls.
    #   The pointer refers to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_unsafe : Pointer(T)
      @array.to_unsafe
    end
  end
end
