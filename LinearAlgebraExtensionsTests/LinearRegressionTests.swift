//
//  LinearRegressionTests.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 16/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import XCTest
import Accelerate
import LinearAlgebraExtensions

class LinearRegressionTests: XCTestCase {
	
	var x: [Double]!
	var y: [Double]!
	var x2: [Double]!
	var y2: [Double]!

    override func setUp() {
        super.setUp()
		
		x = [6.1101,5.5277,8.5186,7.0032,5.8598,8.3829,7.4764,8.5781,6.4862,5.0546,5.7107,14.164,5.734,8.4084,5.6407,5.3794,6.3654,5.1301,6.4296,7.0708,6.1891,20.27,5.4901,6.3261,5.5649,18.945,12.828,10.957,13.176,22.203,5.2524,6.5894,9.2482,5.8918,8.2111,7.9334,8.0959,5.6063,12.836,6.3534,5.4069,6.8825,11.708,5.7737,7.8247,7.0931,5.0702,5.8014,11.7,5.5416,7.5402,5.3077,7.4239,7.6031,6.3328,6.3589,6.2742,5.6397,9.3102,9.4536,8.8254,5.1793,21.279,14.908,18.959,7.2182,8.2951,10.236,5.4994,20.341,10.136,7.3345,6.0062,7.2259,5.0269,6.5479,7.5386,5.0365,10.274,5.1077,5.7292,5.1884,6.3557,9.7687,6.5159,8.5172,9.1802,6.002,5.5204,5.0594,5.7077,7.6366,5.8707,5.3054,8.2934,13.394,5.4369]
		y = [17.592,9.1302,13.662,11.854,6.8233,11.886,4.3483,12,6.5987,3.8166,3.2522,15.505,3.1551,7.2258,0.71618,3.5129,5.3048,0.56077,3.6518,5.3893,3.1386,21.767,4.263,5.1875,3.0825,22.638,13.501,7.0467,14.692,24.147,-1.22,5.9966,12.134,1.8495,6.5426,4.5623,4.1164,3.3928,10.117,5.4974,0.55657,3.9115,5.3854,2.4406,6.7318,1.0463,5.1337,1.844,8.0043,1.0179,6.7504,1.8396,4.2885,4.9981,1.4233,-1.4211,2.4756,4.6042,3.9624,5.4141,5.1694,-0.74279,17.929,12.054,17.054,4.8852,5.7442,7.7754,1.0173,20.992,6.6799,4.0259,1.2784,3.3411,-2.6807,0.29678,3.8845,5.7014,6.7526,2.0576,0.47953,0.20421,0.67861,7.5435,5.3436,4.2415,6.7981,0.92695,0.152,2.8214,1.8451,4.2959,7.2029,1.9869,0.14454,9.0551,0.61705
		]
		
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
	
	//MARK: - Single variable
	func testInitialCost() {
		let linear = LinearRegression(x, y)
		let initialCost = linear.computeCost()
		
		XCTAssertEqualWithAccuracy(initialCost, 32.0727, accuracy: 0.005, "Should have this value for initial cost")
	}

    func testLinearRegression() {
		
		let linear = LinearRegression(x, y)
		
		let results = linear.gradientDescent()

		XCTAssertEqualWithAccuracy(results.theta[0], 1.166362, accuracy: 0.5, "Should have this for first element")
		XCTAssertEqualWithAccuracy(results.theta[1], -3.630291, accuracy: 0.5, "Should have this for second element")
    }
	
	func testMultiVariateLinearRegression() {
		let x2Mat = la_matrix_from_double_array(x2, rows: y2.count, columns: 2)
		let y2Mat = la_matrix_from_double_array(y2, rows: y2.count, columns: 1)
		
		let linear = LinearRegression(x2Mat, y2Mat, numIterations: 400)
		
		let results = linear.gradientDescent(true)
		
		print(results)
	}
	
	func testNormalEquation() {
		
		let linear = LinearRegression(x, y)
		
		let theta = linear.normalEquations()
		XCTAssertEqualWithAccuracy(theta[1], -3.630291, accuracy: 0.5, "Should have this for first element")
		XCTAssertEqualWithAccuracy(theta[0], 1.166362, accuracy: 0.5, "Should have this for second element")
	}
}
