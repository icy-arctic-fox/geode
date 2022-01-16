require "../matrices"

abstract struct Number
  # Scales a matrix by this amount.
  #
  # ```
  # 5 * Matrix[[1, 2, 3], [4, 5, 6]] # => [[5, 10, 15], [20, 25, 30]]
  # ```
  def *(matrix : Geode::CommonMatrix) : Geode::CommonMatrix
    matrix * self
  end
end
