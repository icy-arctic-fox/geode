module Geode
  # Generic vector type.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  # *N* is a positive integer indicating the number of components.
  struct Vector(T, N)
    include Indexable(T)

    # Storage for the vector is implemented with a static array.
    @vec : StaticArray(T, N)

    # Constructs the vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    # The size of the vector is determined by the number of components.
    #
    # ```
    # Geode::Vector[1, 2, 3] # => (1, 2, 3)
    # ```
    macro [](*components)
      {{@type.name(generic_args: false)}}.new(StaticArray[{{*components}}])
    end

    # Constructs the vector with pre-existing values.
    def initialize(@vec : StaticArray(T, N))
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Geode::Vector(Int32, 3).new { |i| i * 5 } # => (0, 5, 10)
    # ```
    def initialize(& : Int32 -> T)
      @vec = StaticArray(T, N).new { |i| yield i }
    end

    # Constructs a zero-vector.
    #
    # Each component will have a scalar value equal to the type's'zero value.
    # This is done by calling `T.zero` for each component.
    # The type *T* must have a class method
    #
    # ```
    # Geode::Vector(Float32, 3).zero # => (0.0, 0.0, 0.0)
    # ```
    def self.zero : self
      new { T.zero }
    end

    # Returns the number of components in this vector.
    def size
      N
    end

    # Returns a new vector where components are mapped by the given block.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.map { |v| v * 2 } # => (2, 4, 6)
    # ```
    def map(& : T -> U) : Vector(U, N) forall U
      Vector(U, N).new { |i| yield unsafe_fetch(i) }
    end

    # Like `#map`, but the block gets the component and its index as arguments.
    #
    # Accepts an optional *offset* parameter, which to start the index at.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.map_with_index { |v, i| v * i } # => (0, 2, 6)
    # vector.map_with_index(3) { |v, i| v + i } # => (4, 6, 8)
    # ```
    def map_with_index(offset = 0, & : (T, Int32) -> U) : Vector(U, N) forall U
      Vector(U, N).new { |i| yield unsafe_fetch(i), offset + i }
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
      @vec.unsafe_fetch(index)
    end

    # Produces a string representation of the vector.
    #
    # The format is: `(x, y, z)`
    # but with the corresponding number of components.
    def to_s(io : IO) : Nil
      io << '('
      join(io, ", ")
      io << ')'
    end

    # Returns a slice that points to the components in this vector.
    #
    # NOTE: The returned slice is only valid for the caller's scope and sub-calls.
    #   The slice points to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_slice : Slice(T)
      @vec.to_slice
    end

    # Returns a pointer to the data for this vector.
    #
    # The components are tightly packed and ordered consecutively in memory.
    #
    # NOTE: The returned pointer is only valid for the caller's scope and sub-calls.
    #   The pointer refers to memory on the stack, it will be invalid after the caller returns.
    @[AlwaysInline]
    def to_unsafe : Pointer(T)
      @vec.to_unsafe
    end
  end
end
