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
	
	var x2: [Double]!
	var y2: [Double]!
	
	override func setUp() {
		super.setUp()
		
		x2 = [2104,3,
			1600,3,
			2400,3,
			1416,2,
			3000,4,
			1985,4,
			1534,3,
			1427,3,
			1380,3,
			1494,3,
			1940,4,
			2000,3,
			1890,3,
			4478,5,
			1268,3,
			2300,4,
			1320,2,
			1236,3,
			2609,4,
			3031,4,
			1767,3,
			1888,2,
			1604,3,
			1962,4,
			3890,3,
			1100,3,
			1458,3,
			2526,3,
			2200,3,
			2637,3,
			1839,2,
			1000,1,
			2040,4,
			3137,3,
			1811,4,
			1437,3,
			1239,3,
			2132,4,
			4215,4,
			2162,4,
			1664,2,
			2238,3,
			2567,4,
			1200,3,
			852,2,
			1852,4,
			1203,3]
		y2 = [399900,
			329900,
			369000,
			232000,
			539900,
			299900,
			314900,
			198999,
			212000,
			242500,
			239999,
			347000,
			329999,
			699900,
			259900,
			449900,
			299900,
			199900,
			499998,
			599000,
			252900,
			255000,
			242900,
			259900,
			573900,
			249900,
			464500,
			469000,
			475000,
			299900,
			349900,
			169900,
			314900,
			579900,
			285900,
			249900,
			229900,
			345000,
			549000,
			287000,
			368500,
			329900,
			314000,
			299000,
			179900,
			299900,
			239500]
	}
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSubscriptAccess() {
        let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
        let matrix = la_matrix_from_array(twoDArray)
        
        XCTAssertNil(matrix[-1, -1])
        
        XCTAssertEqual(matrix[0, 0]!, 1.0, "Should have accessed first element")
        XCTAssertEqual(matrix[1, 2]!, 6.0)
    }

	func testConstructorFromArray() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		var matrix = la_matrix_from_array(twoDArray)
		
		let rhs = 2.0
		let scalarSplat = la_splat_from_double(rhs, 0)
		matrix = la_elementwise_product(matrix, scalarSplat)
		
		XCTAssertEqual(la_matrix_cols(matrix), la_count_t(3), "Should have equals columns in 2D array and matrix")
		XCTAssertEqual(la_matrix_rows(matrix), la_count_t(3), "Should have equals rows in 2D array and matrix")
	}
	
	func testMatrixDescription() {
		let twoDArray = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
		let matrix = la_matrix_from_array(twoDArray)
		print(matrix.description())
		let description = matrix.description()
		XCTAssertNotNil(description, "Should have provided matrix description")
	}
	
	func testIdentityConstructor() {
		let identity = eye(5)
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
	
	func testPrependingColumn() {
		
		let x = [2.0, 2.0, 3.0, 3.0]
		let cols = 2
		let rows = 2
		let xMat = la_matrix_from_double_array(x, rows: rows, columns: cols)
		let ones = la_ones_matrix(xMat.rows)
		let newMat = xMat.prependColumnsFrom(ones)
		
		let newArray = newMat.toArray()

		let expectedResult = [1.0, 2.0, 2.0, 1.0, 3.0, 3.0]
		XCTAssertEqual(newArray, expectedResult, "Expecting given array")
	}
	
	//MARK: - Column append/prepend
	func testMergeFunction() {
		// Extend the values so it takes more time, for better comparison
		for _ in 0..<5 {
			x2.appendContentsOf(x2)
		}
		let cols = 2
		let m = x2.count / 2
		let xMat = la_matrix_from_double_array(x2, rows: m, columns: cols)
		let ones = la_ones_matrix(xMat.rows)
		
		measureBlock {
			_ = ones.appendColumnsFrom(xMat)
		}
	}
}
