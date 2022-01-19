require "./matrices/**"

module Geode
  # Returns a new matrix with the minimum element from each matrix.
  #
  # ```
  # Geode.min(Matrix[[1, 2], [3, 4]], Matrix[[4, 3], [2, 1]) # => [[1, 2], [2, 1 ]]
  # ```
  def self.min(a : CommonMatrix(T, M, N), b : CommonMatrix(T, M, N)) : CommonMatrix forall T, M, N
    a.class.new { |i, j| Math.min(a.unsafe_fetch(i, j), b.unsafe_fetch(i, j)) }
  end

  # Returns a new matrix with the lesser value of the element or *value*.
  #
  # ```
  # Geode.min(Matrix[[1, 2], [3, 4]], 2) # => [[1, 2], [2, 2]]
  # ```
  def self.min(matrix : CommonMatrix(T, M, N), value : T) : CommonMatrix forall T, M, N
    matrix.class.new { |i, j| Math.min(matrix.unsafe_fetch(i, j), value) }
  end

  # Returns a new matrix with the maximum element from each matrix.
  #
  # ```
  # Geode.max(Matrix[[1, 2], [3, 4]], Matrix[[4, 3], [2, 1]]) # => [[4, 3], [3, 4]]
  # ```
  def self.max(a : CommonMatrix(T, M, N), b : CommonMatrix(T, M, N)) : CommonMatrix forall T, M, N
    a.class.new { |i, j| Math.max(a.unsafe_fetch(i, j), b.unsafe_fetch(i, j)) }
  end

  # Returns a new matrix with the greater value of the element or *value*.
  #
  # ```
  # Geode.max(Matrix[[1, 2], [3, 4]], 2) # => [[2, 2], [3, 4]]
  # ```
  def self.max(matrix : CommonMatrix(T, M, N), value : T) : CommonMatrix forall T, M, N
    matrix.class.new { |i, j| Math.max(matrix.unsafe_fetch(i, j), value) }
  end
end
