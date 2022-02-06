require "./common"

module Geode
  # Generic vector type.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  # *N* is a positive integer indicating the number of components.
  struct Vector(T, N)
    include CommonVector(T, N)

    # Storage for the vector is placed on the heap.
    # This allows arbitrarily large vectors.
    # A pointer is used because it only takes 8 bytes (on 64-bit systems),
    # compared to 16 for a `Slice` and 24 for an `Array`.
    @components : Pointer(T)

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

    # Constructs a vector with existing components.
    #
    # The type of the components is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Vector(Float32, 5)[1, 2, 3, 4, 5] # => (1.0, 2.0, 3.0, 4.0, 5.0)
    # ```
    def self.[](*elements)
      new(elements.map { |e| T.new(e) })
    end

    # Copies the contents of another vector.
    def initialize(vector : CommonVector(T, N))
      {% raise "Source vector to copy from must be the same size" if N != @type.type_vars.last %}
      @components = Pointer(T).malloc(N)
      @components.copy_from(vector.to_unsafe, N)
    end

    # Constructs the vector with pre-existing values.
    #
    # The memory allocated for *components* must match the size of the vector.
    def initialize(array : StaticArray(T, N))
      {% raise "Components to copy from must be the same size" if N != @type.type_vars.last %}
      @components = Pointer(T).malloc(N)
      @components.copy_from(array.to_unsafe, N)
    end

    # Creates a new matrix from a collection of components.
    #
    # The size of *components* must be equal to *N*.
    #
    # ```
    # Vector(Int32, 5).new([1, 2, 3, 4, 5]) # => (1, 2, 3, 4, 5)
    # ```
    def initialize(components : Indexable(T))
      raise IndexError.new("Components must be #{N} in size") if components.size != N

      @components = Pointer(T).malloc(size) { |i| components.unsafe_fetch(i) }
    end

    # Constructs the vector with pre-existing values.
    #
    # *components* must be a pointer to pre-allocated memory.
    # The memory allocated for *components* must match the size of the vector.
    protected def initialize(@components : Pointer(T))
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
      @components = Pointer(T).malloc(N) { |i| yield i }
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

    # Retrieves the x component.
    #
    # Raises a compilation error if the vector size (*N*) is less than 1.
    def x : T
      {% raise "Vector does not have an x component (N < 1)" if N < 1 %}

      unsafe_fetch(0)
    end

    # Retrieves the y component.
    #
    # Raises a compilation error if the vector size (*N*) is less than 2.
    def y : T
      {% raise "Vector does not have an x component (N < 2)" if N < 2 %}

      unsafe_fetch(1)
    end

    # Retrieves the z component.
    #
    # Raises a compilation error if the vector size (*N*) is less than 3.
    def z : T
      {% raise "Vector does not have a z component (N < 3)" if N < 3 %}

      unsafe_fetch(2)
    end

    # Retrieves the w component.
    #
    # Raises a compilation error if the vector size (*N*) is less than 4.
    def w : T
      {% raise "Vector does not have a w component (N < 4)" if N < 4 %}

      unsafe_fetch(3)
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
      @components[index]
    end

    # Returns a slice that points to the components in this vector.
    @[AlwaysInline]
    def to_slice : Slice(T)
      @components.to_slice(N)
    end

    # Returns a pointer to the data for this vector.
    #
    # The components are tightly packed and ordered consecutively in memory.
    @[AlwaysInline]
    def to_unsafe : Pointer(T)
      @components
    end
  end
end
