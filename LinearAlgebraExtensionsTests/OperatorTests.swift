//
//  OperatorTests.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import XCTest
import Accelerate
import LinearAlgebraExtensions

class OperatorTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testMatrixMultiply() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray) as la_object_t
		var matrix2 = la_object_t.objectFromArray(twoDArray) as la_object_t
		
		var multiplyMatrix = matrix * matrix2
		
		XCTAssertEqual(la_matrix_cols(multiplyMatrix), 3, "Should have same dimension result")
		XCTAssertEqual(la_matrix_rows(multiplyMatrix), 3, "Should have same dimension result")
		
		var result = multiplyMatrix.toArray()
		
		XCTAssertEqual(result[0], 30, "Should have 30 as result of first element")
	}
	
	func testScalarAdd() {
		let rows = 3
		let cols = 3
		
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray)
		var matrix2 = la_object_t.objectFromArray(twoDArray)
		
		var sumMatrix = matrix + matrix2
		
		var result = sumMatrix.toArray()
		
		for (y, array) in enumerate(twoDArray) {
			for (x, array) in enumerate(array) {
				
				let originalElement = twoDArray[x][y] * 2
				let resultElement = result[y + x * cols]
				
				XCTAssertEqual(originalElement, resultElement, "Should have equal elements at (\(x), \(y))")
			}
		}
	}
	
	func testPerformanceExample() {
		
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = Array<Double>(count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		measureBlock {
			var matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			var matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			
			let result = la_matrix_product(matrix, matrix2)
			
			// Have to actually call it out for execution to occur
			var array = Array<Double>(count: elementCount, repeatedValue: 0.0)
			let status = la_matrix_to_double_buffer(&array, rowDim, result)
		}
	}
	
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
			var matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			var matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
			
			let result = matrix * matrix2
			
			// Have to actually call it out for execution to occur
			var array = Array<Double>(count: elementCount, repeatedValue: 0.0)
			let status = la_matrix_to_double_buffer(&array, rowDim, result)
		}
	}
	
	func testToArrayPerformance() {
		//TODO: last run was 2.707s 1% STDEV!! Needs work on toArray() method
		
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = la_count_t(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		var matrix = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		var matrix2 = la_matrix_from_double_buffer(&array, rowDim, rowDim, rowDim, 0, 0)
		
		let result = matrix * matrix2
		
		measureBlock {
			// Have to actually call it out for execution to occur
			var array = result.toArray()
		}
	}
	
	func testVSPPerformance() {
		let squareDim = 1_024
		let elementCount = Int(pow(Double(squareDim), Double(2.0)))
		let initial = 0.0
		
		let rowDim = vDSP_Stride(squareDim)
		let length = vDSP_Length(squareDim)
		
		var array = [Double](count: elementCount, repeatedValue: initial)
		
		for i in 0..<elementCount {
			array[i] = Double(arc4random_uniform(100))
		}
		
		var m1 = [ 3.0, 2.0, 4.0, 5.0, 6.0, 7.0 ]
		var m2 = [ 10.0, 20.0, 30.0, 30.0, 40.0, 50.0]
		var mresult = [Double](count : 9, repeatedValue : 0.0)
		
		measureBlock {
			var vsresult = [Double](count : array.count, repeatedValue : 0.0)
			vDSP_mmulD(&array, 1, &array, 1, &vsresult, 1, length, length, length)
		}
	}
}
