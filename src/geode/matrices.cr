require "./matrices/**"

module Geode
  # Returns a new matrix with the minimum element from each matrix.
  #
  # ```
  # Geode.min(Matrix[[1, 2], [3, 4]], Matrix[[4, 3], [2, 1]) # => [[1, 2], [2, 1 ]]
  # ```
  def self.min(a : CommonMatrix(T, M, N), b : CommonMatrix(U, M, N)) : CommonMatrix forall T, U, M, N
    a.zip_map(b) { |element_a, element_b| Math.min(element_a, element_b) }
  end

  # Returns a new matrix with the lesser value of the element or *value*.
  #
  # ```
  # Geode.min(Matrix[[1, 2], [3, 4]], 2) # => [[1, 2], [2, 2]]
  # ```
  def self.min(matrix : CommonMatrix(T, M, N), value : U) : CommonMatrix forall T, U, M, N
    matrix.map { |element| Math.min(element, value) }
  end

  # Returns a new matrix with the maximum element from each matrix.
  #
  # ```
  # Geode.max(Matrix[[1, 2], [3, 4]], Matrix[[4, 3], [2, 1]]) # => [[4, 3], [3, 4]]
  # ```
  def self.max(a : CommonMatrix(T, M, N), b : CommonMatrix(U, M, N)) : CommonMatrix forall T, U, M, N
    a.zip_map(b) { |element_a, element_b| Math.max(element_a, element_b) }
  end

  # Returns a new matrix with the greater value of the element or *value*.
  #
  # ```
  # Geode.max(Matrix[[1, 2], [3, 4]], 2) # => [[2, 2], [3, 4]]
  # ```
  def self.max(matrix : CommonMatrix(T, M, N), value : U) : CommonMatrix forall T, U, M, N
    matrix.map { |element| Math.max(element, value) }
  end
end
