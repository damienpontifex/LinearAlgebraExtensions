//
//  Matrix.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

//MARK: - Matrix operations
public func +(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_sum(left, right)
}

public func -(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_difference(left, right)
}

public func *(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_matrix_product(left, right)
}

//MARK: - Scalar operations
public func +(left: la_object_t, right: Double) -> la_object_t {
	let scalarSplat = la_splat_from_double(right, 0)
	return la_sum(left, scalarSplat)
}

public func -(left: la_object_t, right: Double) -> la_object_t {
	let scalarSplat = la_splat_from_double(right, 0)
	return la_difference(left, scalarSplat)
}

public func *(left: la_object_t, right: Double) -> la_object_t {
	let scalarSplat = la_splat_from_double(right, 0)
	return la_elementwise_product(left, scalarSplat)
}

public func /(left: la_object_t, right: Double) -> la_object_t {
	return left * (1.0 / right)
}

public func ^(left: la_object_t, right: Int) -> la_object_t {
	var result: la_object_t?
	for _ in 1..<right {
		if result == nil {
			result = la_matrix_product(left, left)
		} else {
			la_matrix_product(result!, left)
		}
	}
	return result!
}

/**
Construct a la_object_t for a matrix of dimensions rows x columns

- parameter The: array to use as the elements of the matrix
- parameter The: number of rows to construct the matrix
- parameter The: number of columns to construct the matrix

- returns: The la_object_t instance to use in matrix operations
*/
public func la_matrix_from_double_array(_ array: [Double], rows: Int, columns: Int) -> la_object_t {
	let columns = la_count_t(columns)
	let rows = la_count_t(rows)
	
	let stride = columns
	var matrix: la_object_t!
    var mutableArray = array
    matrix = la_matrix_from_double_buffer(&mutableArray, rows, columns, stride, 0, 0)
	
	return matrix
}

/**
Construct a la_object_t for a column matrix of size array.count x 1

- parameter The: array to use as the elements of the column matrix

- returns: The la_object_t instance to use in matrix operations
*/
public func la_vector_column_from_double_array(_ array: [Double]) -> la_object_t {
	return la_matrix_from_double_array(array, rows: array.count, columns: 1)
}

/**
Construct a la_object_t for a row matrix of size 1 x array.count

- parameter The: array to use as the elements of the column matrix

- returns: The la_object_t instance to use in matrix operations
*/
public func la_vector_row_from_double_array(_ array: [Double]) -> la_object_t {
	return la_matrix_from_double_array(array, rows: 1, columns: array.count)
}

/**
Construct a la_object_t for a matrix of repeated values with dimensions rows x columns

- parameter The: array to use as the elements of the matrix
- parameter The: number of rows to construct the matrix, defaults to one
- parameter The: number of columns to construct the matrix, defaults to one

- returns: The la_object_t instance to use in matrix operations
*/
public func la_constant_matrix(_ value: Double, rows: Int = 1, columns: Int = 1) -> la_object_t {
	let matrixArray = [Double](repeating: value, count: rows * columns)
	return la_matrix_from_double_array(matrixArray, rows: rows, columns: columns)
}

/**
Construct a la_object_t for a matrix with all elements set to 0.0 of dimensions rows x columns

- parameter The: number of rows to construct the matrix, defaults to one
- parameter The: number of columns to construct the matrix, defaults to one

- returns: The la_object_t instance to use in matrix operations
*/
public func la_zero_matrix(_ rows: Int = 1, columns: Int = 1) -> la_object_t {
	return la_constant_matrix(0.0, rows: rows, columns: columns)
}

/**
Construct a la_object_t for a matrix with all elements set to 1.0 of dimensions rows x columns

- parameter The: number of rows to construct the matrix, defaults to one
- parameter The: number of columns to construct the matrix, defaults to one

- returns: The la_object_t instance to use in matrix operations
*/
public func la_ones_matrix(rows: Int = 1, columns: Int = 1) -> la_object_t {
	return la_constant_matrix(1.0, rows: rows, columns: columns)
}

/**
Construct a la_object_t for a matrix with random numbers between 0.0 and 1.0 of dimensions rows x columns

-parameter:		The number of rows to construct the matrix, defaults to one
- parameter:	The number of columns to construct the matrix, defaults to one

- returns:		The la_object_t instance to use in matrix operations
*/
public func la_rand_matrix(_ rows: Int = 1, columns: Int = 1) -> la_object_t {	
	let max = Double(UInt32.max)
	
	let values = (0..<rows*columns).map { _ in 
		return Double(arc4random()) / max
	}
	
	return la_matrix_from_double_array(values, rows: rows, columns: columns)
}
	
/**
Construct a la_object_t from a Swift two dimensional array

- parameter array: The array of elements from which to construct the la_object

- returns: The la_object_t instance to use in matrix operations
*/
public func la_matrix_from_array(_ array: [[Double]]) -> la_object_t {
    let rows = array.count
    let columns = array.first?.count ?? 1
//		let totalElements = Int(rows * columns)
    
    let grid = array.flatMap { $0 }
    
    return la_matrix_from_double_array(grid, rows: rows, columns: columns)
}

/**
Construct a la_object_t identity matrix

- parameter The: dimension of the square identity matrix

- returns: The identity la_object_t instance to use in matrix operations
*/
public func la_matrix_identity(_ dimension: Int = 1) -> la_object_t {
    let size = la_count_t(dimension)
    let scalarType = la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE)
    let attributes = la_attribute_t(LA_DEFAULT_ATTRIBUTES)
    return la_identity_matrix(size, scalarType, attributes)
}

//MARK: - Object access
extension la_object_t {
	
	/// Convenience accessor for row count
	final public var rows: Int {
		return Int(la_matrix_rows(self))
	}

	/// Convenience accessor for column count
	final public var cols: Int {
		return Int(la_matrix_cols(self))
	}

	/**
	Merge two matrices by columns with the second being placed before self
	
	- parameter secondMat: The matrix to prepend
	
	- returns: The merged matrix
	*/
	final public func prependColumnsFrom(_ secondMat: la_object_t) -> la_object_t {
		return secondMat.appendColumnsFrom(self)
	}
	
	/**
	Merge two matrices by columns with the second being placed after self
	
	- parameter secondMat: The matrix to append
	
	- returns: The merged matrix
	*/
	final public func appendColumnsFrom(_ secondMat: la_object_t) -> la_object_t {
		
		assert(self.rows == secondMat.rows, "Cannot append columns from matrices of two different row dimensions")
		
//		var selfT = la_transpose(self)
		let secondT = la_transpose(secondMat)
		
		var selfArr = self.toArray()
		selfArr.append(contentsOf: secondT.toArray())
		
		let end = la_matrix_from_double_array(selfArr, rows: self.cols + secondMat.cols, columns: self.rows)
		return la_transpose(end)
	}
	
	/**
	*  Slice the matrix and return a new matrix with the specified row and column range
	*
	*  @param Range<Int> The range of row elements to create the slice from
	*  @param Range<Int> The range of column elements to create the slice from
	*
	*  @return A new la_object_t instance with the subset of the original object from the specified rows and columns
	*/
	final public subscript(rowRange: Range<Int>, colRange: Range<Int>) -> la_object_t {
		return la_matrix_slice(self, rowRange.lowerBound, colRange.lowerBound, 0, 0, la_count_t(rowRange.upperBound - rowRange.lowerBound), la_count_t(colRange.upperBound - colRange.lowerBound))
	}
	
	/**
	Generate a swift array of elements from the la_object_t instance
	
	- returns: A one dimensional swift array with all the elements from the la_object_t instance
	*/
	final public func toArray() -> [Double] {
		var array = [Double](repeating: 0.0, count: rows * cols)
		
		_ = la_matrix_to_double_buffer(&array, la_count_t(cols), self)
		
//		assertStatusIsSuccess(status)
		
		return array
	}
    
    final public subscript(x: Int, y: Int) -> Double? {
        if x >= 0 && x < rows && y >= 0 && y < cols {
            let slice = la_matrix_slice(self, x, y, 0, 0, 1, 1)
            return slice.toArray().first
        }
        
        return nil
    }
	
	/**
	la_status_t to friendly string converter
	
	- parameter status: The status returned from the matrix operation
	*/
	final fileprivate func assertStatusIsSuccess(_ status: la_status_t) {
		switch Int32(status) {
		case LA_WARNING_POORLY_CONDITIONED:
			assert(false, "Poorly conditioned")
		case LA_INTERNAL_ERROR:
			assert(false, "Internal error")
		case LA_INVALID_PARAMETER_ERROR:
			assert(false, "Invalid parameter error")
		case LA_DIMENSION_MISMATCH_ERROR:
			assert(false, "Dimension mismatch error")
		case LA_PRECISION_MISMATCH_ERROR:
			assert(false, "Precision mismatch error")
		case LA_SINGULAR_ERROR:
			assert(false, "Singular error")
		case LA_SLICE_OUT_OF_BOUNDS_ERROR:
			assert(false, "Out of bounds error")
		case LA_SUCCESS:
			fallthrough
		default:
			break
		}
	}
}

//MARK: - Printable
extension la_object_t {
	final public func description() -> String {
		
		let outputArray = toArray()
		
        let rowDescriptions = (0..<rows).map { x -> String in
            let valDescriptions = (0..<self.cols).map { y -> String in
                outputArray[Int(y + x * self.cols)].description
            }
            let commaJoinedVals = valDescriptions.joined(separator: ", ")
            return commaJoinedVals
        }
        
        let rowsJoinedByLine = rowDescriptions.joined(separator: "\n")
		
		return rowsJoinedByLine
	}
}
