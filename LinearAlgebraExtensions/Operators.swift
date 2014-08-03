//
//  Operators.swift
//  LinearAlgebraExtensions
//
//  Created by Damien Pontifex on 3/08/2014.
//  Copyright (c) 2014 Damien Pontifex. All rights reserved.
//

import Foundation
import Accelerate

// Matrix operations
func + (lhs: la_object_t, rhs: la_object_t) -> la_object_t {
	return la_sum(lhs, rhs)
}

func - (lhs: la_object_t, rhs: la_object_t) -> la_object_t {
	return la_difference(lhs, rhs)
}

func * (lhs: la_object_t, rhs: la_object_t) -> la_object_t {
	return la_matrix_product(lhs, rhs)
}

// Scalar operations
func + (lhs: la_object_t, rhs: Double) -> la_object_t {
	let scalarSplat = la_splat_from_double(rhs, 0)
	return la_sum(lhs, scalarSplat)
}

func - (lhs: la_object_t, rhs: Double) -> la_object_t {
	let scalarSplat = la_splat_from_double(rhs, 0)
	return la_difference(lhs, scalarSplat)
}