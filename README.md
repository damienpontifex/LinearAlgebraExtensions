LinearAlgebraExtensions
=======================

Extensions to simplify the use of the LinearAlgebra framework on iOS 8 and OS X 10.10 utilising Swift operator overloading

## Matrix
Construct a matrix from a Swift Array

```
let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
var matrix = la_object_t.objectFromArray(twoDArray)
```

## Operators

```
var A: la_object_t
var B: la_object_t
```

Matrix multiplication with operator overloading
```
let C = A * B
```

Matrix multiplication without
```
let C = la_matrix_product(A, B)
```

Matrix element multiplication with operator overloading
```
let C = A * 2
```
Matrix element multiplication without
```
let scalarSplat = la_splat_from_double(rhs, 0)
let C = la_elementwise_product(lhs, scalarSplat)
```

## Matrix Constructors

- [Double] to column matrix
- [Double] to row matrix
- [[Double]] to matrix with size of the contained arrays
- [Double] to matrix of specified row x columns
- Ones matrix
- Zeros matrix
- Repeated values matrix
- Identity matrix


## Matrix Operations

- matrix * matrix : Matrix multiplication
- matrix + matrix : Matrix addition
- matrix - matrix : Matrix subtraction

## Scalar Operations

- matrix * Double : Scalar elementwise multiplication
- matrix + Double : Scalar elementwise addition
- matrix - Double : Scalar elementwise subtraction
- matrix^Double : Scalar elementwise power