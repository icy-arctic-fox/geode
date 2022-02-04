require "./vectors/**"

module Geode
  # Returns a new vector with the minimum component from each vector.
  #
  # ```
  # Geode.min(Vector[1, 2, 3], Vector[3, 2, 1]) # => (1, 2, 1)
  # ```
  def self.min(a : CommonVector(T, N), b : CommonVector(U, N)) : CommonVector forall T, U, N
    a.zip_map(b) { |component_a, component_b| Math.min(component_a, component_b) }
  end

  # Returns a new vector with the lesser value of the component or *value*.
  #
  # ```
  # Geode.min(Vector[1, 2, 3], 2) # => (1, 2, 2)
  # ```
  def self.min(vector : CommonVector(T, N), value : U) : CommonVector forall T, U, N
    vector.map { |component| Math.min(component, value) }
  end

  # Returns a new vector with the maximum component from each vector.
  #
  # ```
  # Geode.max(Vector[1, 2, 3], Vector[3, 2, 1]) # => (3, 2, 3)
  # ```
  def self.max(a : CommonVector(T, N), b : CommonVector(U, N)) : CommonVector forall T, U, N
    a.zip_map(b) { |component_a, component_b| Math.max(component_a, component_b) }
  end

  # Returns a new vector with the greater value of the component or *value*.
  #
  # ```
  # Geode.max(Vector[1, 2, 3], 2) # => (2, 2, 3)
  # ```
  def self.max(vector : CommonVector(T, N), value : U) : CommonVector forall T, U, N
    vector.map { |component| Math.max(component, value) }
  end
end
