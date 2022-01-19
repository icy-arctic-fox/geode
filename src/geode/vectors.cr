require "./vectors/**"

module Geode
  # Returns a new vector with the minimum component from each vector.
  #
  # ```
  # Geode.min(Vector[1, 2, 3], Vector[3, 2, 1]) # => (1, 2, 1)
  # ```
  def self.min(a : CommonVector(T, N), b : CommonVector(T, N)) : CommonVector forall T, N
    a.class.new { |i| Math.min(a.unsafe_fetch(i), b.unsafe_fetch(i)) }
  end

  # Returns a new vector with the lesser value of the component or *value*.
  #
  # ```
  # Geode.min(Vector[1, 2, 3], 2) # => (1, 2, 2)
  # ```
  def self.min(vector : CommonVector(T, N), value : T) : CommonVector forall T, N
    vector.class.new { |i| Math.min(vector.unsafe_fetch(i), value) }
  end

  # Returns a new vector with the maximum component from each vector.
  #
  # ```
  # Geode.max(Vector[1, 2, 3], Vector[3, 2, 1]) # => (3, 2, 3)
  # ```
  def self.max(a : CommonVector(T, N), b : CommonVector(T, N)) : CommonVector forall T, N
    a.class.new { |i| Math.max(a.unsafe_fetch(i), b.unsafe_fetch(i)) }
  end

  # Returns a new vector with the greater value of the component or *value*.
  #
  # ```
  # Geode.max(Vector[1, 2, 3], 2) # => (2, 2, 3)
  # ```
  def self.max(vector : CommonVector(T, N), value : T) : CommonVector forall T, N
    vector.class.new { |i| Math.max(vector.unsafe_fetch(i), value) }
  end
end
