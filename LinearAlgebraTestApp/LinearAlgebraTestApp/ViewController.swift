//
//  ViewController.swift
//  LinearAlgebraTestApp
//
//  Created by Damien Pontifex on 23/06/2015.
//  Copyright (c) 2015 Pontifex. All rights reserved.
//

import Cocoa
import Accelerate
import LinearAlgebraExtensions
import CorePlot

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let linear = CPTScaleType.Linear
		let graph = CPTXYGraph(frame: view.frame, xScaleType: linear, yScaleType: linear)
		graph.title = "Scatter graph"
		
		let scatter = CPTScatterPlot(frame: view.frame)
		scatter.dataSource = DataSource()
		
		let host = CPTGraphHostingView(frame: view.frame)
		host.hostedGraph = graph
		view.addSubview(host)
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

class DataSource: NSObject, CPTPlotDataSource {
	func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
		return 10
	}
	
	func numbersForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndexRange indexRange: NSRange) -> [AnyObject]! {
		return la_rand_matrix(10, columns: 1, numberGenerator: NumberGenerators.UniformDistribution).toArray()
	}
}