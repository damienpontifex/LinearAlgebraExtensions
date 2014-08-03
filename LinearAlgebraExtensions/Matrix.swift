//
//  Matrix.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

extension la_object_t: Printable {
	class func objectFromArray(array: [Array<Double>]) -> la_object_t {
		let rows = la_count_t(array.count)
		let columns = la_count_t(array[0].count)
		let totalElements = Int(rows * columns)
		
		var grid = Array<Double>(count: totalElements, repeatedValue: 0.0)
		for (index, rowArray) in enumerate(array) {
			grid.replaceRange(Range<Int>(start: index * rowArray.count, end: (index + 1) * rowArray.count), with: rowArray)
		}
		
		var pointer = UnsafePointer<Double>.alloc(totalElements)
		pointer.initializeFrom(grid)
		
		let stride = columns
		
		return la_matrix_from_double_buffer(pointer, rows, columns, stride, 0, 0)
	}
	
	subscript(rowRange: Range<Int>, colRange: Range<Int>) -> la_object_t {
		return la_matrix_slice(self, rowRange.startIndex, colRange.startIndex, 0, 0, la_count_t(rowRange.endIndex - rowRange.startIndex), la_count_t(colRange.endIndex - colRange.startIndex))
	}
	
	public var description: String {
	get {
		let rows = la_matrix_rows(self)
		let cols = la_matrix_cols(self)
		
		var buffer = UnsafePointer<Double>.alloc(Int(rows * cols))
		la_matrix_to_double_buffer(buffer, cols, self)
		
		let outputArray = UnsafeArray<Double>(start: buffer, length: Int(rows * cols))
		
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
}