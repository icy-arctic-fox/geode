# Spec helper module for testing tolerances.
module Tolerance
  # Ensures that all elements/components of *vec_mat* (a vector or matrix) are within tolerance.
  #
  # The *values* should be in-order to match *vec_mat*'s elements.
  # Optionally set the *tolerance* to a custom value.
  macro expect_within_tolerance(vec_mat, *values, tolerance = :TOLERANCE)
    aggregate_failures do
      {% for value, index in values %}
        expect({{vec_mat.id}}[{{index}}]).to be_within({{tolerance.id}}).of({{value}})
      {% end %}
    end
  end
end
