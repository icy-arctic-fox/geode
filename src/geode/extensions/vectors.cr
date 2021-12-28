require "../vectors"

abstract struct Number
  # Scales a vector by this amount.
  #
  # ```
  # 5 * Vector[2, 3, 4] # => (10, 15, 20)
  # ```
  def *(vector : Geode::CommonVector) : Geode::CommonVector
    vector * self
  end
end
