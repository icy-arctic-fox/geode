require "./common"

module Geode
  # Generic vector type.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  # *N* is a positive integer indicating the number of components.
  struct Vector(T, N)
    include CommonVector(T, N)

    # Storage for the vector is implemented with a static array.
    @array : StaticArray(T, N)

    # Constructs the vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    # The size of the vector is determined by the number of components.
    #
    # ```
    # Vector[1, 2, 3] # => (1, 2, 3)
    # ```
    macro [](*components)
      {{@type.name(generic_args: false)}}.new(StaticArray[{{*components}}])
    end

    # Copies the contents of another vector.
    def initialize(vector : CommonVector(T, N))
      {% raise "Source vector to copy from must be the same size" if N != @type.type_vars.last %}
      @array = StaticArray(T, N).new { |i| vector.unsafe_fetch(i) }
    end

    # Constructs the vector with pre-existing values.
    def initialize(@array : StaticArray(T, N))
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector(Int32, 3).new { |i| i * 5 } # => (0, 5, 10)
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
    # Vector(Float32, 3).zero # => (0.0, 0.0, 0.0)
    # ```
    def self.zero : self
      new { T.zero }
    end

    # Returns a new vector where components are mapped by the given block.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.map { |v| v * 2 } # => (2, 4, 6)
    # ```
    def map(& : T -> U) : CommonVector forall U
      Vector(U, N).new { |i| yield unsafe_fetch(i) }
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
