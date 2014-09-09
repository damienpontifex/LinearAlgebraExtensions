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
	
	func testMatrixMultiplyOperator() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray) as la_object_t
		var matrix2 = la_object_t.objectFromArray(twoDArray) as la_object_t
		
		var multiplyMatrix = matrix * matrix2
		
		XCTAssertEqual(la_matrix_cols(multiplyMatrix), 3, "Should have same dimension result")
		XCTAssertEqual(la_matrix_rows(multiplyMatrix), 3, "Should have same dimension result")
		
		var result = multiplyMatrix.toArray()
		
		XCTAssertEqual(result[0], 30, "Should have 30 as result of first element")
	}
	
	func testMatrixAddOperator() {
		let rows = 3
		let cols = 3
		
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray)
		var matrix2 = la_object_t.objectFromArray(twoDArray)
		
		var sumMatrix = matrix + matrix2
		
		var result = sumMatrix.toArray()
		
		// Verify
		for (y, array) in enumerate(twoDArray) {
			for (x, array) in enumerate(array) {
				
				let originalElement = twoDArray[x][y] * 2
				let resultElement = result[y + x * cols]
				
				XCTAssertEqual(originalElement, resultElement, "Should have equal elements at (\(x), \(y))")
			}
		}
	}
}
