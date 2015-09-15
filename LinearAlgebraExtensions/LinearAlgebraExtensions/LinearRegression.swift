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
public class LinearRegression: NSObject {
	
	private var m: Int
	private var x: la_object_t
	private var y: la_object_t
	private var theta: la_object_t
	private var alpha: Double
	private var numIterations: Int
	
	public init(_ x: la_object_t, _ y: la_object_t, theta: la_object_t? = nil, alpha: Double = 0.01, numIterations: Int = 1500) {
		self.m = Int(la_matrix_rows(x))
		_ = Int(la_matrix_cols(x))
		
		let ones = la_ones_matrix(Int(la_matrix_rows(x)))
		self.x = x.prependColumnsFrom(ones)
		self.y = y
		
		if theta != nil {
			self.theta = theta!
		} else {
			self.theta = la_zero_matrix(columns: Int(la_matrix_cols(self.x)))
		}
		self.alpha = alpha
		self.numIterations = numIterations
		
		super.init()
	}
	
	/**
	Initialise the LinearRegression object
	
	- parameter x:             Input data values
	- parameter y:             Expected output values
	- parameter theta:         Initial theta value
	- parameter alpha:         Learning rate
	- parameter numIterations: Number of iterations to run the algorithm
	
	- returns: Instance of the LinearRegression
	*/
	public init(_ x: [Double], _ y: [Double], thetaArray: [Double]? = nil, alpha: Double = 0.01, numIterations: Int = 1500) {
		self.m = x.count
		
		var xValues = Array<Double>(count: m * 2, repeatedValue: 1.0)
		for i in 0.stride(to: x.count * 2, by: 2) {
			xValues[i] = x[i / 2]
		}
		
		var xMatrix = la_matrix_from_double_array(xValues, rows: m, columns: 2)
		
		self.x = xMatrix
		
		self.y = la_vector_column_from_double_array(y)
		
		if let thetaArray = thetaArray {
			self.theta = la_vector_row_from_double_array(thetaArray)
		} else {
			self.theta = la_zero_matrix(2)
		}
		
		self.alpha = alpha
		self.numIterations = numIterations
		
		super.init()
	}
	
	/**
	Run the gradient descent algorithm for linear regression
	
	- parameter returnCostHistory: Boolean value to indicate whether the cost history should be returned. Some performance hit if this is true due to doing array computations in every iteration rather than just at the end
	
	- returns: Tuple of theta values and optional jHistory parameter if requested
	*/
	public func gradientDescent(returnCostHistory: Bool = false) -> (theta: [Double], jHistory: [Double]?) {
		
		print("initial theta \(theta.description())")
		print(x.description())
		print(y.description())
		
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
			let sum = la_transpose(errors) * x
			let partial = la_transpose(sum) * alphaOverM
			
			// Simultaneous theta update:
			// theta_j = theta_j - alpha / m * sum_{i=1}^m (h_theta(x^(i)) - y^(i)) * x_j^(i)
			theta = theta - partial
			
			print("next theta \(theta.description())")
			
			if returnCostHistory {
				jHistory![iter] = computeCost()
			}
		}
		
		let thetaArray = theta.toArray()
		
		return (theta: thetaArray, jHistory: jHistory)
	}
	
	/**
	Calculate theta values using the normal equations.
	
	- returns: Double array with theta coefficients
	*/
	public func normalEquations() -> [Double] {
		// 𝜃 = inverse(X' * X) * X' * y
		// Equivalent to (X' * X) * 𝜃 = X' * y hence can use la_solve
		let newTheta = la_solve(la_transpose(x) * x, la_transpose(x) * y)
		
		return newTheta.toArray()
	}
	
	/**
	Computes the cost with our current values of theta
	
	- returns: Cost value for the data with value of theta
	*/
	public func computeCost() -> Double {
		
		let twoM = 2.0 * Double(m)
		
		let xTheta = x * theta
		let diff = xTheta - y
		
		var partial = diff^2
		partial = partial / twoM
		
		return partial.toArray().first!
	}
}
