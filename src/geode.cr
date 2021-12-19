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
  def self.edge(value : T, edge : T) forall T
    value < edge ? T.zero : T.new(1)
  end
end

require "./geode/*"
