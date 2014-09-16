//
//  LinearRegression.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 16/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

/**
*  Class to calculate linear regression of a set of data points
*/
public class LinearRegression {
	
	private var m: Int
	private var x: la_object_t
	private var y: la_object_t
	private var theta: la_object_t
	private var alpha: Double
	private var numIterations: Int
	
	/**
	Initialise the LinearRegression object
	
	:param: x             Input data values
	:param: y             Expected output values
	:param: theta         Initial theta value
	:param: alpha         Learning rate
	:param: numIterations Number of iterations to run the algorithm
	
	:returns: Instance of the LinearRegression
	*/
	public init(_ x: [Double], _ y: [Double], theta: [Double] = [0.0, 0.0], alpha: Double = 0.001, numIterations: Int = 1500) {
		self.m = x.count
		
		var xValues = Array<Double>(count: m * 2, repeatedValue: 1.0)
		for i in stride(from: 0, to: x.count * 2, by: 2) {
			xValues[i] = x[i / 2]
		}
		var xMatrix = la_object_t.matrixFromArray(xValues, rows: m, columns: 2)
		
		self.x = xMatrix
		
		self.y = la_object_t.columnMatrixFromArray(y)
		self.theta = la_object_t.rowMatrixFromArray(theta)
		self.alpha = alpha
		self.numIterations = numIterations
	}
	
	/**
	Run the gradient descent algorithm for linear regression
	
	:param: returnCostHistory Boolean value to indicate whether the cost history should be returned. Some performance hit if this is true due to doing array computations in every iteration rather than just at the end
	
	:returns: Tuple of theta values and optional jHistory parameter if requested
	*/
	public func gradientDescent(returnCostHistory: Bool = false) -> (theta: [Double], jHistory: [Double]?) {
		
		// Number of training examples
		let alphaOverM = alpha / Double(m)
		
		var jHistory: [Double]?
		if returnCostHistory {
			jHistory = Array<Double>(count: numIterations, repeatedValue: 0.0)
		}
		
		for iter in 0..<numIterations {
			// h(x) = transpose(theta) * x
			let prediction = x * theta
			let errors = prediction - y
			
			let partial = la_transpose(la_transpose(errors) * x) * alphaOverM
			
			// Simultaneous theta update:
			// theta_j = theta_j - alpha / m * sum_{i=1}^m (h_theta(x^(i)) - y^(i)) * x_j^(i)
			theta = theta - partial
			
			if returnCostHistory {
				jHistory![iter] = computeCost()
			}
		}
		
		let thetaArray = theta.toArray()
		
		return (theta: thetaArray, jHistory: jHistory)
	}
	
	/**
	Computes the cost with our current values of theta
	
	:returns: Cost value for the data with value of theta
	*/
	public func computeCost() -> Double {
		
		let twoM = 2.0 * Double(m)
		
		let xTheta = x * theta
		let diff = xTheta - y
		
		var partial = diff^2
		partial = partial / twoM
		
		let partialArray = partial.toArray()
		let sum = partialArray.reduce(0.0, combine: { result, val in
			return result + val
		})
		
		return sum
	}
}
