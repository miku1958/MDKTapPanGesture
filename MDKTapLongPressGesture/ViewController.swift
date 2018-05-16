//
//  ViewController.swift
//  MDKTapLongPressGesture
//
//  Created by mikun on 2018/5/15.
//  Copyright © 2018年 mdk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let panView = UIView()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let ges = MDKTapPanGesture()
		ges.addTarget(self, action: #selector(handleGestrue(ges:)))
		view.addGestureRecognizer(ges)

		panView.frame = view.bounds
		panView.backgroundColor = .red
		view.addSubview(panView)
	}

	@objc func handleGestrue(ges:MDKTapPanGesture) -> () {
		let tran = ges.translation(in: view)
		print(tran)
		let inset = -tran.y
		panView.frame = view.frame.insetBy(dx: inset, dy: inset)
	}
}

