abstract struct Number
  # Returns the inverse of this value.
  #
  # ```
  # 2.inv    # => 0.5
  # 0.25.inv # => 4.0
  # ```
  def inv
    self.class.multiplicative_identity / self
  end
end
