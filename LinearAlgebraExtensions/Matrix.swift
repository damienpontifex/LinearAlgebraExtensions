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

public func ^(left: la_object_t, right: Int) -> la_object_t {
	var result: la_object_t?
	for i in 1..<right {
		if result == nil {
			result = la_matrix_product(left, left)
		} else {
			la_matrix_product(result!, left)
		}
	}
	return result!
}

extension la_object_t: Printable {
	
	/**
	Construct a la_object_t from a Swift two dimensional array
	
	:param: array The array of elements from which to construct the la_object
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func objectFromArray(array: [[Double]]) -> la_object_t {
		let rows = array.count
		let columns = array[0].count
		let totalElements = Int(rows * columns)
		
		// Flatten out the array
		var grid = [Double](count: totalElements, repeatedValue: 0.0)
		for (index, rowArray) in enumerate(array) {
			let replacementRange = Range<Int>(start: index * rowArray.count, end: (index + 1) * rowArray.count)
			grid.replaceRange(replacementRange, with: rowArray)
		}
		
		return matrixFromArray(grid, rows: rows, columns: columns)
	}
	
	/**
	Construct a la_object_t for a column matrix of size array.count x 1
	
	:param: The array to use as the elements of the column matrix
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func columnMatrixFromArray(var array: [Double]) -> la_object_t {
		return matrixFromArray(array, rows: array.count, columns: 1)
	}
	
	/**
	Construct a la_object_t for a row matrix of size 1 x array.count
	
	:param: The array to use as the elements of the column matrix
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func rowMatrixFromArray(var array: [Double]) -> la_object_t {
		return matrixFromArray(array, rows: 1, columns: array.count)
	}
	
	/**
	Construct a la_object_t for a matrix of dimensions rows x columns
	
	:param: The array to use as the elements of the matrix
	:param: The number of rows to construct the matrix
	:param: The number of columns to construct the matrix
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func matrixFromArray(var array: [Double], rows: Int, columns: Int) -> la_object_t {
		let columns = la_count_t(columns)
		let rows = la_count_t(rows)
		let totalElements = Int(rows * columns)
		
		let stride = columns
		var matrix: la_object_t!
		matrix = la_matrix_from_double_buffer(&array, rows, columns, stride, 0, 0)
		
		return matrix
	}
	
	/**
	Construct a la_object_t for a matrix of repeated values with dimensions rows x columns
	
	:param: The array to use as the elements of the matrix
	:param: The number of rows to construct the matrix, defaults to one
	:param: The number of columns to construct the matrix, defaults to one
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func matrixWithRepeatedValue(value: Double, rows: Int = 1, columns: Int = 1) -> la_object_t {
		var matrixArray = [Double](count: rows * columns, repeatedValue: value)
		return matrixFromArray(matrixArray, rows: rows, columns: columns)
	}
	
	/**
	Construct a la_object_t for a matrix with all elements set to 1.0 of dimensions rows x columns
	
	:param: The number of rows to construct the matrix, defaults to one
	:param: The number of columns to construct the matrix, defaults to one
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func ones(rows: Int = 1, columns: Int = 1) -> la_object_t {
		return matrixWithRepeatedValue(1.0, rows: rows, columns: columns)
	}
	
	/**
	Construct a la_object_t for a matrix with all elements set to 0.0 of dimensions rows x columns
	
	:param: The number of rows to construct the matrix, defaults to one
	:param: The number of columns to construct the matrix, defaults to one
	
	:returns: The la_object_t instance to use in matrix operations
	*/
	public class func zeros(rows: Int = 1, columns: Int = 1) -> la_object_t {
		return matrixWithRepeatedValue(0.0, rows: rows, columns: columns)
	}
	
	/**
	Construct a la_object_t identity matrix
	
	:param: The dimension of the square identity matrix
	
	:returns: The identity la_object_t instance to use in matrix operations
	*/
	public class func eye(_ dimension: Int = 1) -> la_object_t {
		let size = la_count_t(dimension)
		let scalarType = la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE)
		let attributes = la_attribute_t(LA_DEFAULT_ATTRIBUTES)
		return la_identity_matrix(size, scalarType, attributes)
	}
	
	/**
	*  Slice the matrix and return a new matrix with the specified row and column range
	*
	*  @param Range<Int> The range of row elements to create the slice from
	*  @param Range<Int> The range of column elements to create the slice from
	*
	*  @return A new la_object_t instance with the subset of the original object from the specified rows and columns
	*/
	public subscript(rowRange: Range<Int>, colRange: Range<Int>) -> la_object_t {
		return la_matrix_slice(self, rowRange.startIndex, colRange.startIndex, 0, 0, la_count_t(rowRange.endIndex - rowRange.startIndex), la_count_t(colRange.endIndex - colRange.startIndex))
	}
	
	public var description: String {
	get {
		let rows = la_matrix_rows(self)
		let cols = la_matrix_cols(self)
		
		let outputArray = toArray()
		
		var _desc = ""
		for (idx, val) in enumerate(outputArray) {
			_desc += val.description
			
			if (idx + 1) % cols == 0 {
				_desc += "\n"
			} else {
				_desc += " "
			}
		}
		
		return _desc
	}
	}
	
	/**
	Generate a swift array of elements from the la_object_t instance
	
	:returns: A one dimensional swift array with all the elements from the la_object_t instance
	*/
	public func toArray() -> [Double] {
		let rows = la_matrix_rows(self)
		let cols = la_matrix_cols(self)
		
		var array = [Double](count: Int(rows * cols), repeatedValue: 0.0)
		let status = la_matrix_to_double_buffer(&array, cols, self)
//		assertStatusIsSuccess(status)

		return array
	}
	
	/**
	la_status_t to friendly string converter
	
	:param: status The status returned from the matrix operation
	*/
	private func assertStatusIsSuccess(status: la_status_t) {
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
