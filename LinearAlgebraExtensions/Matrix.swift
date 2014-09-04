//
//  Matrix.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

// Matrix operations
public func +(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_sum(left, right)
}

public func -(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_difference(left, right)
}

public func *(left: la_object_t, right: la_object_t) -> la_object_t {
	return la_matrix_product(left, right)
}

// Scalar operations
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
	for var i = 1; i < right; i++ {
		if result == nil {
			result = la_matrix_product(left, left)
		} else {
			la_matrix_product(result!, left)
		}
	}
	return result!
}

extension la_object_t: Printable {
	public class func objectFromArray(array: [Array<Double>]) -> la_object_t {
		let rows = la_count_t(array.count)
		let columns = la_count_t(array[0].count)
		let totalElements = Int(rows * columns)
		
		var grid = Array<Double>(count: totalElements, repeatedValue: 0.0)
		for (index, rowArray) in enumerate(array) {
			grid.replaceRange(Range<Int>(start: index * rowArray.count, end: (index + 1) * rowArray.count), with: rowArray)
		}

		let stride = columns
		var matrix: la_object_t!
		matrix = la_matrix_from_double_buffer(&grid, rows, columns, stride, 0, 0)
		
		return matrix
	}
	
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
	
	public func toArray() -> Array<Double> {
		let rows = la_matrix_rows(self)
		let cols = la_matrix_cols(self)
		
		var array = Array<Double>(count: Int(rows * cols), repeatedValue: 0.0)
		let status = la_matrix_to_double_buffer(&array, cols, self)
		assertStatusIsSuccess(status)

		return array
	}
	
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
