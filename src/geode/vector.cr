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
    # The type of the components is derived from the type of the components.
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
  end
end
