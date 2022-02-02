Geode
=====

Mathematics library for Crystal supporting vectors, matrices, quaternions, and more.

The goal of Geode is to be an expressive and performant mathematics library.
Geode attempts to distill concepts down to their basic components.
Types, such as vectors and matrices, can be used with any numeric primitive (int or float) and any dimensionality.
Whenever possible, Geode will produce a compilation error for invalid operations instead of raising a runtime error.
E.g. multiplying matrices with mismatched side lengths.

Installation
------------

Add this to your application's `shard.yml`:

```yaml
dependencies:
  geode:
    gitlab: arctic-fox/geode
    version: ~> 0.1.0
```

Usage
-----

This README explains the design of Geode and basic usage.
For detailed information on usage and available function, please check the [documentation](https://arctic-fox.gitlab.io/geode).

It may be useful to `include Geode` in your code to avoid name-spacing.
Examples here and in the documentation omit the `Geode::` prefix for brevity.

### Common Types

Most types have a "base" type and a collection of modules that implement functionality.
The base type defines the underlying data structure and fundamental access patterns.
Any specifics of the type are also defined in the base.
The base types include a "common" module.
The common module then includes all other modules as mix-ins.
This pattern allows any "common" type to be used as an argument instead of relying on a base type.

Take for example a 2D vector that has two components.

```crystal
struct Vector2D(T)
  include CommonVector2D

  getter x : T, y : T
end

struct Vector2DArray(T)
  include CommonVector2D

  @array : StaticArray(T, 2)

  def x
    @array[0]
  end

  def y
    @array[1]
  end
end
```

`Vector2D` and `Vector2DArray` are base types.
They both include the `CommonVector2D` module.
The functions in `CommonVector2D` and all other mix-ins will work, regardless of the base type used.
This allows fundamental properties and rules to be reused across types without duplicating code.
It also allows the base type to decide the optimal design for storing and accessing data.

### Immutable

All types are immutable unless otherwise specified.

### Extension Methods

Methods add to types defined outside this shard are called extensions.
These methods are optional and *not* included by default.
To enable them, do:

```crystal
require "geode/extensions"
```

Most of these methods provide syntactic sugar.
See each "extensions" section below for details on what is exposed.

### Vectors

Vectors types come in two groups: fixed-size and generic.
Both use the common type [`CommonVector`](https://arctic-fox.gitlab.io/geode/Geode/CommonVector.html).
Vector types include [`Indexable`](https://crystal-lang.org/api/latest/Indexable.html).

Vector size is a compile-time constant.
A compilation error will be raised for any operations where the sizes between vectors don't match.
For instance, adding two vectors with different sizes.

#### Fixed-size

Fixed-size vectors are named `VectorN` where `N` is the dimensionality of the vector.
There are 4 vectors of this type: [`Vector1`](https://arctic-fox.gitlab.io/geode/Geode/Vector1.html) through [`Vector4`](https://arctic-fox.gitlab.io/geode/Geode/Vector4.html).
Each takes a type parameter which is the scalar value stored for each component.
Additionally, there are aliases for the common numerical types.

- `VectorNI` - `I` for integer, 32-bit integers
- `VectorNL` - `L` for long, 64-bit integers
- `VectorNF` - `F` for float, 32-bit floating points
- `VectorND` - `D` for double, 64-bit floating points

To create a fixed-size vector, one of the initializer methods can be used, the simplest being:

```crystal
Vector3.new(x, y, z)
```

The short-hand bracket-notation `[]` can also be used.

```crystal
Vector3[x, y, z]
```

Fixed-size vectors also have convenience methods specific to their size.
The `#x`, `#y`, `#z`, and `#w` getters are available for their corresponding sized vectors.

[`Vector2`](https://arctic-fox.gitlab.io/geode/Geode/Vector2.html) has angle methods [`#angle`](https://arctic-fox.gitlab.io/geode/Geode/Vector2.html#angle%3ANumber-instance-method),
[`#signed_angle`](https://arctic-fox.gitlab.io/geode/Geode/Vector2.html#signed_angle%28other%3ACommonVector%28U%2C2%29%29%3ANumberforallU-instance-method),
and [`#rotate`](https://arctic-fox.gitlab.io/geode/Geode/Vector2.html#rotate%28angle%3ANumber%7CAngle%29%3Aself-instance-method).
[`Vector3`](https://arctic-fox.gitlab.io/geode/Geode/Vector1.html) has angle methods [`#alpha`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#alpha%3ANumber-instance-method),
[`#beta`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#beta%3ANumber-instance-method),
[`#gamma`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#gamma%3ANumber-instance-method),
[`#rotate_x`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#rotate_x%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
[`#rotate_y`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#rotate_y%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
[`#rotate_z`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#rotate_z%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
and [`#cross`](https://arctic-fox.gitlab.io/geode/Geode/Vector3.html#cross%28other%3ACommonVector%28U%2C3%29%29%3ACommonVectorforallU-instance-method) (cross-product).
These methods are not available on the generic vector type (even if their dimensionality is 2 or 3).

All fixed-size vector use the base type [`VectorBase`](https://arctic-fox.gitlab.io/geode/Geode/VectorBase.html).

#### Generic

Generic vectors are defined by the [`Vector`](https://arctic-fox.gitlab.io/geode/Geode/Vector.html) type.
They can have an arbitrarily large size, however, the size must be known at compile-time.
Generic vectors take two type arguments: the component type and size.
This is similar to [`StaticArray`](https://crystal-lang.org/api/latest/StaticArray.html).

```crystal
Vector(Float64, 7).new({1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0})
```

The short-hand bracket-notation `[]` can also be used.

```crystal
Vector[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
```

#### Functions

Some common vector functions are listed below.

- Standard operations:
  [`+`](https://arctic-fox.gitlab.io/geode/Geode/VectorOperations.html#%2B%28other%3ACommonVector%28T%2CN%29%29%3ACommonVectorforallT-instance-method),
  [`-`](https://arctic-fox.gitlab.io/geode/Geode/VectorOperations.html#-%28other%3ACommonVector%28T%2CN%29%29%3ACommonVectorforallT-instance-method),
  [`*`](https://arctic-fox.gitlab.io/geode/Geode/VectorOperations.html#%2A%28scalar%3ANumber%29%3ACommonVector-instance-method),
  [`/`](https://arctic-fox.gitlab.io/geode/Geode/VectorOperations.html#/%28scalar%3ANumber%29%3ACommonVector-instance-method)
- Geometric operations:
  [`#dot`](https://arctic-fox.gitlab.io/geode/Geode/VectorGeometry.html#dot%28other%3ACommonVector%28T%2CN%29%29forallT-instance-method),
  [`#mag`](https://arctic-fox.gitlab.io/geode/Geode/VectorGeometry.html#mag-instance-method),
  [`#mag2`](https://arctic-fox.gitlab.io/geode/Geode/VectorGeometry.html#mag2-instance-method),
  [`#normalize`](https://arctic-fox.gitlab.io/geode/Geode/VectorGeometry.html#normalize%3ACommonVector-instance-method),
  [`#project`](https://arctic-fox.gitlab.io/geode/Geode/VectorGeometry.html#project%28other%3ACommonVector%28T%2CN%29%29%3ACommonVectorforallT-instance-method)
- Matrix operations:
  [`*`](https://arctic-fox.gitlab.io/geode/Geode/VectorMatrices.html#%2A%28matrix%3ACommonMatrix%28U%2CM%2CM%29%29%3ACommonVectorforallU%2CM-instance-method),
  [`#to_row`](https://arctic-fox.gitlab.io/geode/Geode/VectorMatrices.html#to_row%3ACommonMatrix-instance-method),
  [`#to_column`](https://arctic-fox.gitlab.io/geode/Geode/VectorMatrices.html#to_column%3ACommonMatrix-instance-method)

#### Extensions

There is a single extension method for vectors: [`*`](https://arctic-fox.gitlab.io/geode/Number.html#%2A%28vector%3AGeode%3A%3ACommonVector%29%3AGeode%3A%3ACommonVector-instance-method).
This allows multiplying a vector by a scalar, where the scalar is in front.

```crystal
5 * Vector[1, 2, 3] # => (5, 10, 15)
```

Without this extension, all vector multiplication requires the vector on the left of the `*` operator.

#### Considerations

The fixed-size vectors store their values *on the stack*.
Generic vectors store their values *on the heap*.
For 1-4 dimensions, the fixed-size vectors are recommended.
In general, they will be faster and provide more functions since size is explicit.
For arbitrarily large dimensions, a generic vector should be used.

### Matrices

Like vectors, matrices come in two styles: fixed-size and generic.
Both use the common type [`CommonMatrix`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html).
Matrix types include [`Indexable`](https://crystal-lang.org/api/latest/Indexable.html) - see 'Indexing' section below for details.

Matrix dimensions are compile-time constants.
A compilation error will be raised for any operations where the sizes between matrices don't match.
For instance, multiplying matrices with mismatched dimensions.

Matrix types are complex and have a lot of methods.

#### Fixed-size

Fixed-size matrices are named `MatrixMxN` where `M` and `N` are the rows and columns respectively.
There are 16 matrices of this type: [`Matrix1x1`](https://arctic-fox.gitlab.io/geode/Geode/Matrix1x1.html) through [`Matrix4x4`](https://arctic-fox.gitlab.io/geode/Geode/Matrix4x4.html).
Each takes a type parameter which is the scalar value stored for each entry.
Additionally, there are aliases for the common square types.

- [`Matrix1`](https://arctic-fox.gitlab.io/geode/Geode/Matrix1.html) - Short for [`Matrix1x1`](https://arctic-fox.gitlab.io/geode/Geode/Matrix1x1.html)
- [`Matrix2`](https://arctic-fox.gitlab.io/geode/Geode/Matrix2.html) - Short for [`Matrix2x2`](https://arctic-fox.gitlab.io/geode/Geode/Matrix2x2.html)
- [`Matrix3`](https://arctic-fox.gitlab.io/geode/Geode/Matrix3.html) - Short for [`Matrix3x3`](https://arctic-fox.gitlab.io/geode/Geode/Matrix3x3.html)
- [`Matrix4`](https://arctic-fox.gitlab.io/geode/Geode/Matrix4.html) - Short for [`Matrix4x4`](https://arctic-fox.gitlab.io/geode/Geode/Matrix4x4.html)

To create a fixed-size matrix, one of the initializer methods can be used, the simplest being:

```crystal
Matrix3x2.new({{1, 2, 3}, {4, 5, 6}})
```

The short-hand bracket-notation `[]` can also be used.

```crystal
Matrix3x2[[1, 2, 3], [4, 5, 6]]
```

The initializers use nested collections, where each element of the outer collection is a row.
These could also be written like so for readability:

```crystal
Matrix3x3[
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
```

Fixed-size matrices [`Matrix1x1`](https://arctic-fox.gitlab.io/geode/Geode/Matrix1x1.html),
[`Matrix2x2`](https://arctic-fox.gitlab.io/geode/Geode/Matrix2x2.html),
[`Matrix3x3`](https://arctic-fox.gitlab.io/geode/Geode/Matrix3x3.html),
and [`Matrix4x4`](https://arctic-fox.gitlab.io/geode/Geode/Matrix4x4.html)
include [`SquareMatrix`](https://arctic-fox.gitlab.io/geode/Geode/SquareMatrix.html).
This provides extra methods specifically for square matrix types.
These also have an [`.identity`](https://arctic-fox.gitlab.io/geode/Geode/Matrix3x3.html#identity%3Aself-class-method) constructor that create an identity matrix.

#### Generic

Generic matrices are defined by the [`Matrix`](https://arctic-fox.gitlab.io/geode/Geode/Matrix.html) type.
They can have an arbitrarily large size, however, the size must be known at compile-time.
Generic vectors take three type arguments: the component type, the rows, and columns.
Rows and columns are represented as integers `M` and `N` respectively.
This is similar to [`StaticArray`](https://crystal-lang.org/api/latest/StaticArray.html).

```crystal
Matrix(Float64, 2, 7).new({
  {1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1},
  {1.2, 2.2, 3.2, 4.2, 5.2, 6.2, 7.2}
})
```

The short-hand bracket-notation `[]` can also be used.

```crystal
Matrix[
  [1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1],
  [1.2, 2.2, 3.2, 4.2, 5.2, 6.2, 7.2]
]
```

The initializers use nested collections, where each element of the outer collection is a row.

The [`Matrix`](https://arctic-fox.gitlab.io/geode/Geode/Matrix.html) generic type includes [`SquareMatrix`](https://arctic-fox.gitlab.io/geode/Geode/SquareMatrix.html) for convenience,
but will generate a compilation error if they're called on non-square matrices.

#### Functions

Some common matrix functions are listed below.

- Size:
  [`#rows`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#rows%3AInt-instance-method),
  [`#columns`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#columns%3AInt-instance-method),
  [`#size`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#size-instance-method)
  [`#square?`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#square%3F-instance-method)
- Indexers: 
  [`#row`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#row%28i%3AInt%29%3ACommonVector%28T%2CN%29-instance-method),
  [`#column`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#column%28j%3AInt%29%3ACommonVector%28T%2CM%29-instance-method),
  [`#each_row`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#each_row%28%26%3ACommonVector%28T%2CN%29-%3E_%29-instance-method),
  [`#each_column`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#each_column%28%26%3ACommonVector%28T%2CM%29-%3E_%29-instance-method)
- Standard operations:
  [`+`](https://arctic-fox.gitlab.io/geode/Geode/MatrixOperations.html#%2B%28other%3ACommonMatrix%28T%2CM%2CN%29%29%3ACommonMatrixforallT-instance-method),
  [`-`](https://arctic-fox.gitlab.io/geode/Geode/MatrixOperations.html#-%28other%3ACommonMatrix%28T%2CM%2CN%29%29%3ACommonMatrixforallT-instance-method),
  [`*`](https://arctic-fox.gitlab.io/geode/Geode/MatrixOperations.html#%2A%28scalar%3ANumber%29%3ACommonMatrix-instance-method),
  [`/`](https://arctic-fox.gitlab.io/geode/Geode/MatrixOperations.html#/%28scalar%3ANumber%29%3ACommonMatrix-instance-method)
  [`#transpose`](https://arctic-fox.gitlab.io/geode/Geode/Matrix.html#transpose%3AMatrix%28T%2CN%2CM%29-instance-method)
  [`#sub`](https://arctic-fox.gitlab.io/geode/Geode/Matrix.html#sub%28i%3AInt%2Cj%3AInt%29%3ACommonMatrix-instance-method)
- Square matrices:
  [`#diagonal`](https://arctic-fox.gitlab.io/geode/Geode/SquareMatrix.html#diagonal%3ACommonVector%28T%2CN%29-instance-method),
  [`#trace`](https://arctic-fox.gitlab.io/geode/Geode/SquareMatrix.html#trace-instance-method),
  [`#determinant`](https://arctic-fox.gitlab.io/geode/Geode/SquareMatrix.html#determinant-instance-method)
- Vector operations:
  [`*`](https://arctic-fox.gitlab.io/geode/Geode/MatrixVectors.html#%2A%28vector%3ACommonVector%28U%2CP%29%29%3ACommonVectorforallU%2CP-instance-method)
  [`#row?`](https://arctic-fox.gitlab.io/geode/Geode/MatrixVectors.html#row%3F-instance-method),
  [`#column?`](https://arctic-fox.gitlab.io/geode/Geode/MatrixVectors.html#column%3F-instance-method),
  [`#to_vector`](https://arctic-fox.gitlab.io/geode/Geode/MatrixVectors.html#to_vector%3ACommonVector-instance-method)
- Transforms (2D):
  [`.reflect_x`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms2.html#reflect_x%3Aself-instance-method),
  [`.reflect_y`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms2.html#reflect_y%3Aself-instance-method),
  [`.rotate`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms2.html#rotate%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
  [`.scale`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms2.html#scale%28amount%3AT%29%3Aself-instance-method)
- Transforms (3D):
  [`.reflect_x`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#reflect_x%3Aself-instance-method),
  [`.reflect_y`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#reflect_y%3Aself-instance-method),
  [`.reflect_z`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#reflect_z%3Aself-instance-method),
  [`.rotate`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#rotate%28angle%3ANumber%7CAngle%2Caxis%3ACommonVector%28T%2C3%29%29%3Aself-instance-method),
  [`.rotate_x`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#rotate_x%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
  [`.rotate_y`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#rotate_y%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
  [`.rotate_z`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#rotate_z%28angle%3ANumber%7CAngle%29%3Aself-instance-method),
  [`.scale`](https://arctic-fox.gitlab.io/geode/Geode/MatrixTransforms3.html#scale%28amount%3AT%29%3Aself-instance-method)

#### Multiplication

Matrices of any size can be multiplied together, provided their dimensions match.
Geode will know at compile-time the resulting matrix size.
Recall that *MxN x NxP = MxP*.

```crystal
m1 = Matrix[[1, 2, 3], [4, 5, 6]]
m2 = Matrix[[1], [10], [100]]
m1 * m2 # => [[321], [654]]
```

Matrices and vectors can be multiplied together.
*Order matters* in this case.
When multiplying a matrix by a vector (*M x v*),
the vector is treated as a column vector (matrix with one column).
Conversely, multiplying a vector by a matrix (*v x M*),
the vector is treated as a row vector (matrix with one row).

```crystal
mat = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
vec = Vector[1, 10, 100]
mat * vec # => (321, 654, 987)
vec * mat # => (741, 852, 963)
```

#### Indexing

Matrices use two indexing modes: row-column and flat.

Row-column indexing is the common way of referencing entries in a matrix.
It uses `i` and `j` to represent the row and column indices respectively.
`i` ranges from 0 to *M - 1* and `j` ranges from 0 to *N - 1*.
Entries can be accessed by using the [`#[]`](https://arctic-fox.gitlab.io/geode/Geode/CommonMatrix.html#%5B%5D%28i%3AInt%2Cj%3AInt%29%3AT-instance-method) method with two arguments: `i` and `j`.

Flat indexing uses a single index from 0 to *M x N - 1*.
It counts in [row-major order](https://en.wikipedia.org/wiki/Row-_and_column-major_order).
This indexing method is primarily used when dealing with [`Indexable`](https://crystal-lang.org/api/latest/Indexable.html) methods provided by the Crystal standard library.

Methods and their documentation use the following conventions to distinguish between indexing modes:

- The word "indices" refers to row-column indexing, while "index" refers to flat indexing.
- The variables `i` and `j` are used for row-column indexing, while `index` is used for flat indexing.

```crystal
matrix.each_indices do |i, j|
  # ...
end

matrix.each_index do |index|
  # ...
end
```

#### Extensions

There is a single extension method for matrices: [`*`](https://arctic-fox.gitlab.io/geode/Number.html#%2A%28matrix%3AGeode%3A%3ACommonMatrix%29%3AGeode%3A%3ACommonMatrix-instance-method).
This allows multiplying a matrix by a scalar, where the scalar is in front.

```crystal
5 * Matrix[[1, 2, 3], [4, 5, 6]] # => [[5, 10, 15], [20, 25, 30]]
```

Without this extension, all matrix multiplication requires the matrix on the left of the `*` operator.

#### Considerations

The fixed-size matrices store their values *on the stack*.
Generic matrices store their values *on the heap*.
For side lengths 1-4, the fixed-size matrices are recommended.
In general, they will be faster and provide more functions since size is explicit.
For arbitrarily large matrices, a generic matrix should be used.

All matrices have their elements laid out in [row-major order](https://en.wikipedia.org/wiki/Row-_and_column-major_order).

### Angles

Geode provides types for some angle units.
The currently supported units are:
[`Degrees`](https://arctic-fox.gitlab.io/geode/Geode/Degrees.html),
[`Radians`](https://arctic-fox.gitlab.io/geode/Geode/Radians.html),
[`Turns`](https://arctic-fox.gitlab.io/geode/Geode/Turns.html),
[`Gradians`](https://arctic-fox.gitlab.io/geode/Geode/Gradians.html)

As a refresher, degrees are measured from 0 to 360;
radians from 0 to 2π or τ;
and gradians from 0 to 400.
Turns is an angle from 0 to 1, like a revolution.

Angles are created by passing their numerical value to an initializer.

```crystal
Degrees.new(90)
Radians.new(Math::PI / 2)
Turns.new(0.25)
Gradians.new(100)
```

The following common angles are available as constructors on all types:
[`.zero`](https://arctic-fox.gitlab.io/geode/Geode/Angle.html#zero%3Aself-class-method),
[`.quarter`](https://arctic-fox.gitlab.io/geode/Geode/Degrees.html#quarter%3Aself-class-method),
[`.third`](https://arctic-fox.gitlab.io/geode/Geode/Degrees.html#third%3Aself-class-method),
[`.half`](https://arctic-fox.gitlab.io/geode/Geode/Degrees.html#half%3Aself-class-method),
[`.full`](https://arctic-fox.gitlab.io/geode/Geode/Degrees.html#full%3Aself-class-method)

```crystal
Radians(Float64).third
```

Angle types have a type parameter, which is the underlying numerical type.
Keep this in mind when performing calculations.

```crystal
Degrees.new(30) * 2 # 60 degrees (represented as Int32)
```

Usually you will want to use a floating point number.

```crystal
Degrees.new(30.0) * 2 # 60.0 degrees (represented as Float64)
```

Angles can be converted by using a `#to_x` method, where `x` is the type to convert to (e.g. `#to_radians`).
An angle can be converted to a numerical type in radians by calling [`#to_f`](https://arctic-fox.gitlab.io/geode/Geode/Angle.html#to_f%3AFloat-instance-method).
Anywhere in Geode where an angle is accepted, one of these unit types can be used, for instance [`Vector2#rotate`](https://arctic-fox.gitlab.io/geode/Geode/Vector2.html#rotate%28angle%3ANumber%7CAngle%29%3Aself-instance-method).

All angle types have a base type of [`Angle`](https://arctic-fox.gitlab.io/geode/Geode/Angle.html).
Angles can have basic math operations performed on them (`+`, `-`, `*`, `/`) even with different units.
The [`#normalize`](https://arctic-fox.gitlab.io/geode/Geode/Angle.html#normalize%3Aself-instance-method) method will correct an angle so that it is between 0 and 1 revolution.

```crystal
Degrees.new(540).normalize # 180 degrees
```

Angles can be stepped with an iterator (see [`Steppable`](https://crystal-lang.org/api/latest/Steppable.html)).

```crystal
0.degrees.step to: 180, by: 5.degrees
```

#### Extensions

The angle extension methods provide syntax sugar for creating angles.
Similar to how the Crystal's standard library exposes time span methods, such as [`#hours`](https://crystal-lang.org/api/latest/Int.html#hours%3ATime%3A%3ASpan-instance-method), the same can be done with angles.
There are two groups of extensions.

The first simply creates an angle of the specified unit from the numerical value.

```crystal
90.degrees
Math::PI.radians
```

is effectively the same as:

```crystal
Degrees.new(90)
Radians.new(Math::PI)
```

There is a method for each unit type:
[`#degrees`](https://arctic-fox.gitlab.io/geode/Number.html#degrees-instance-method),
[`#radians`](https://arctic-fox.gitlab.io/geode/Number.html#radians-instance-method),
[`#turns`](https://arctic-fox.gitlab.io/geode/Number.html#turns-instance-method),
[`#gradians`](https://arctic-fox.gitlab.io/geode/Number.html#gradians-instance-method)

Additionally, there are extension methods that convert their numerical value from radians to the desired unit.

```crystal
(Math::PI / 2).to_degrees # 90 degrees
Math::PI.to_turns         # 0.5 turns
```

is effectively the same as:

```crystal
(Math::PI / 2).radians.to_degrees
Math::PI.radians.to_turns
```

There is a method for each unit type:
[`#to_degrees`](https://arctic-fox.gitlab.io/geode/Number.html#to_degrees-instance-method),
[`#to_radians`](https://arctic-fox.gitlab.io/geode/Number.html#to_radians-instance-method),
[`#to_turns`](https://arctic-fox.gitlab.io/geode/Number.html#to_turns-instance-method),
[`#to_gradians`](https://arctic-fox.gitlab.io/geode/Number.html#to_gradians-instance-method)

#### Considerations

At a low-level, angle types provide a wrapper around a numerical value.
The methods in these wrappers are aware of their unit (radians, degrees, etc.).
The numerical value is stored as-is and not converted.
For instance, specifying `45.degrees` will not convert to radians and will store the value `45` in memory.
Units are converted only when necessary.

Development
-----------

This shard is still in active development.
New features are being added and existing functionality improved.

### Feature Progress

In no particular order, features that have been implemented and are planned.
Items not marked as completed may have partial implementations.

- [ ] Vectors
    - [X] Vector1
    - [X] Vector2
    - [X] Vector3
    - [X] Vector4
    - [X] Vector
    - [X] Common
    - [X] Operations
    - [X] Geometry
    - [X] Matrices
    - [X] Comparison
    - [ ] Unit optimizations
- [ ] Matrices
    - [X] Matrix1xN (1x1, 1x2, 1x3, 1x4)
    - [X] Matrix2xN (2x1, 2x2, 2x3, 2x4)
    - [X] Matrix3xN (3x1, 3x2, 3x3, 3x4)
    - [X] Matrix4xN (4x1, 4x2, 4x3, 4x4)
    - [X] Matrix
    - [X] Common
    - [X] Operations
    - [ ] Square
        - [X] Diagonal
        - [X] Trace
        - [ ] Determinant for generic matrices
        - [ ] Inverse
    - [X] Vectors
    - [X] Transforms
        - [X] 2D
        - [X] 3D
        - [ ] Projection
    - [X] Iterators
    - [X] Comparison
- [ ] Quaternions
- [ ] Polar
    - [ ] 2D
    - [ ] Spherical 3D
    - [ ] Cylindrical 3D
- [ ] Angles
    - [X] Radians
    - [X] Degrees
    - [X] Turns
    - [X] Gradians
    - [ ] Byte degrees
    - [X] Extensions & conversions
- [ ] Primitives
    - [ ] Shapes
    - [ ] Lines
    - [ ] Points
    - [ ] Planes
- [ ] Curves
    - [ ] Polynomial
    - [ ] Bézier
    - [ ] Splines
- [ ] Functions
    - [X] Lerp
    - [ ] Slerp
    - [X] Edge
    - [X] Min/max
- [X] Extensions
    - [X] Angles
    - [X] Vector scalar
    - [X] Matrix scalar

Contributing
------------

1. Fork it (GitHub <https://github.com/icy-arctic-fox/geode/fork> or GitLab <https://gitlab.com/arctic-fox/geode/fork/new>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull/Merge Request

Please make sure to run `crystal tool format` before submitting.
The CI build checks for properly formatted code.
[Ameba](https://crystal-ameba.github.io/) is run to check for code style.

Documentation is automatically generated and published to GitLab pages.
It can be found here: https://arctic-fox.gitlab.io/geode

This project's home is (and primarily developed) on [GitLab](https://gitlab.com/arctic-fox/geode).
A mirror is maintained to [GitHub](https://github.com/icy-arctic-fox/geode).
Issues, pull requests (merge requests), and discussion are welcome on both.
Maintainers will ensure your contributions make it in.

### Testing

Tests must be written for any new functionality.

The `spec/` directory contains feature tests as well as unit tests.
These demonstrate small bits of functionality.
The feature tests are grouped into sub directories based on their type.

[Spectator](https://gitlab.com/arctic-fox/spectator) is used for testing.
The test suite is broken apart for CI builds to reduce compilation time.
