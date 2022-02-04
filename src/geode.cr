# Mathematics library supporting vectors, matrices, quaternions, and more.
module Geode
  # Current version of the Geode library.
  VERSION = {{ `shards version "#{__DIR__}"`.stringify.chomp }}

  # Returns 0 if the value is less than the edge value or 1 if it's greater.
  #
  # ```
  # 0.edge(1) # => 0
  # 2.edge(1) # => 1
  # ```
  def self.edge(value : T, edge) forall T
    value < edge ? T.zero : T.multiplicative_identity
  end

  # Calculates the linear interpolation between two values.
  #
  # *t* is a value from 0 to 1, where 0 represents *a* and 1 represents *b*.
  # Any value between 0 and 1 will result in a proportional amount of *a* and *b*.
  #
  # This method uses the precise calculation
  # that does not suffer precision loss from high exponential differences.
  def self.lerp(a, b, t : Number)
    a * (t.class.new(1) - t) + b * t
  end
end

require "./geode/angles"
require "./geode/matrices"
require "./geode/vectors"
