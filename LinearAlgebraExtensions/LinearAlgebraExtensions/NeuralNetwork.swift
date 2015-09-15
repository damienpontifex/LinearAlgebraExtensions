//
//  NeuralNetwork.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 27/09/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

//func sigmoid(z: la_object_t) -> la_object_t {
//	let g = 1.0 / (1.0 + exp(-1.0 * z))
//	return g
//}

class NeuralNetwork: NSObject {
	
	var inputLayerSize: Int
	var hiddenLayerSize: Int
	var outputLayerSize: Int
	
	var theta1: la_object_t
	var theta2: la_object_t
	
	var m = 0
	
	init(inputLayerSize: Int, numberHidden: Int, outputSize: Int) {
		self.inputLayerSize = inputLayerSize
		self.hiddenLayerSize = numberHidden
		self.outputLayerSize = outputSize
		
		// theta1 should be of dimensions hiddenLayerSize x (inputLayerSize + 1)
		theta1 = la_rand_matrix(self.hiddenLayerSize, columns: self.inputLayerSize + 1, numberGenerator: NumberGenerators.NormalDistribution())
		
		// theta2 should be of dimensions outputLayerSize x (hiddenLayerSize + 1)
		theta2 = la_rand_matrix(self.outputLayerSize, columns: self.hiddenLayerSize + 1, numberGenerator: NumberGenerators.NormalDistribution())
		
		super.init()
	}
	
	func nnCostFunction(x: la_object_t, y: la_object_t, lambda: Double) {
		// Set the number of samples we have
		m = x.rows
		
		for i in 0..<m {
			
		}
	}
}