//
//  OperatorPerformanceTests.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 9/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import XCTest
import Accelerate
import LinearAlgebraExtensions

class OperatorPerformanceTests: XCTestCase {
	
	// Pure la matrix operations for standard
	func testPerformanceExample() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		measureBlock {
			let matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			let matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			
			let result = la_matrix_product(matrix, matrix2)
			
			// Have to actually call it out for execution to occur
			var outArray = Array<Double>(count: elementCount, repeatedValue: 0.0)
			_ = la_matrix_to_double_buffer(&outArray, rowDim, result)
		}
	}
	
	// Performance with custom operator for matrix multiplication
	// Rest standard pure la functions
	func testPerformanceWithMultiplierOperator() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		measureBlock {
			let matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			let matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			
			let result = matrix * matrix2
			
			// Have to actually call it out for execution to occur
			var array = Array<Double>(count: elementCount, repeatedValue: 0.0)
			_ = la_matrix_to_double_buffer(&array, rowDim, result)
		}
	}
	
	// Performance with helper method to convert back to Swift array
	// Rest standard pure la functions
	func testToArrayPerformance() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		let matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		let matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		
		let result = la_matrix_product(matrix, matrix2)
		
		measureBlock {
			// Have to actually call it out for execution to occur
			_ = result.toArray()
		}
	}
	
	// Performance with all custom functions for multiplication and array conversion
	func testAllExtensionFunctionsCombined() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		let matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		let matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		
		measureBlock {
			let result = matrix * matrix2
			
			// Have to actually call it out for execution to occur
			_ = result.toArray()
		}
	}
	
	// testing vDSP for comparison to Linear Algebra framework
	func testVSPPerformance() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		_ = vDSP_Stride(squareDim)
		let length = vDSP_Length(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		measureBlock {
			var vsresult = [Double](count : array.count, repeatedValue : 0.0)
			vDSP_mmulD(&array, 1, &array, 1, &vsresult, 1, length, length, length)
		}
	}
}
