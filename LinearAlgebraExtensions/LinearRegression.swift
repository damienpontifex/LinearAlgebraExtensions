//
//  LinearRegression.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 16/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

public class LinearRegression {
	public class func gradientDescent(x: [Double], _ y: [Double], theta: [Double] = [0.0, 0.0], alpha: Double = 0.001, numIterations: Int = 1500) -> [Double] {
		
		assert(x.count == y.count, "Should have matching value count in x and y ")
		
		let m = x.count
		let alphaOverM = alpha / Double(m)
		
		var xValues = Array<Double>(count: m * 2, repeatedValue: 1.0)
		for i in stride(from: 0, to: x.count * 2, by: 2) {
			xValues[i] = x[i / 2]
		}
		var xMatrix = la_object_t.matrixFromArray(xValues, rows: m, columns: 2)
		
		let onesColumn = la_object_t.ones(columns: x.count)

		let yMatrix = la_object_t.columnMatrixFromArray(y)
		var thetaMatrix = la_object_t.rowMatrixFromArray(theta)
		
		for iter in 0..<numIterations {
			let prediction = xMatrix * thetaMatrix
			let errors = prediction - yMatrix
			
			let partial = la_transpose(la_transpose(errors) * xMatrix) * alphaOverM
			
			thetaMatrix = thetaMatrix - partial
		}
		
		let thetaArray = thetaMatrix.toArray()
		
		return thetaArray
	}
}
