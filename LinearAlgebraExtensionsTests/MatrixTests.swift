//
//  MatrixTests.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import XCTest
import Accelerate
import LinearAlgebraExtensions

class MatrixTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testConstructorFromArray() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray)
		
		let rhs = 2.0
		let scalarSplat = la_splat_from_double(rhs, 0)
		matrix = la_elementwise_product(matrix, scalarSplat)
		
		XCTAssertEqual(la_matrix_cols(matrix), 3, "Should have equals columns in 2D array and matrix")
		XCTAssertEqual(la_matrix_rows(matrix), 3, "Should have equals rows in 2D array and matrix")
	}
	
	func testMatrixDescription() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_object_t.objectFromArray(twoDArray)
		
		let description = matrix.description
		XCTAssertNotNil(description, "Should have provided matrix description")
	}
	
	func testIdentityConstructor() {
		let identity = la_object_t.eye(5)
		let identityArray = identity.toArray()
		
		for x in 0..<5 {
			for y in 0..<5 {
				if x == y {
					XCTAssertEqual(identityArray[y + x * 5], 1, "Should have one on all the diagonal elements")
				} else {
					XCTAssertEqual(identityArray[y + x * 5], 0, "Should have zero on all the non-diagonal elements")
				}
			}
		}
	}
}
