//
//  MDKTwoTapLongPressGesture.swift
//  MDKTwoTapLongPressGesture
//
//  Created by mikun on 2018/5/14.
//  Copyright © 2018年 mdk. All rights reserved.
//

import UIKit

open class MDKTapPanGesture: UIPanGestureRecognizer{
	open var tapCount = 2
	open var maxTimeTimeInterval:TimeInterval = 0.25

	private var tapingCount = 0
	private var lastTapTime:TimeInterval = 0

	private var _state:UIGestureRecognizerState = .possible

	open func state() -> UIGestureRecognizerState{
		return _state;
	}

	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let now = NSDate().timeIntervalSince1970

		if now - lastTapTime > maxTimeTimeInterval {
			self.finishTapPress()
		}

		tapingCount += 1
		lastTapTime = now
		if tapCount == tapingCount {
			super.touchesBegan(touches, with: event!)
		}
	}

	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if tapingCount == tapCount {
			_state = .began

			super.touchesMoved(touches, with: event!)
			self.notiTargetPerformAction()

			_state = .possible
		}
	}

	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event!)
		self.finishTapPress()
	}
	private func finishTapPress() -> () {
		tapingCount = 0
		lastTapTime = 0
	}
	private func notiTargetPerformAction() -> () {
		guard let _targets = self.value(forKey: "_targets") as? Array<AnyObject> else { return }

		for  _targetActionPair in _targets {//UIGestureRecognizerTarget
			var targetActionPair = _targetActionPair
			let selector = NSSelectorFromString("_sendActionWithGestureRecognizer:");

			guard let target = targetActionPair.value(forKey: "_target") as? AnyObject else {return}
			if target.isKind(of: NSClassFromString("UIGestureRecognizerTarget")!){
				//测试的时候发现,某些情况下 target才是UIGestureRecognizerTarget,以防万一这里判断一下
				targetActionPair = target
			}

			if (targetActionPair.responds(to: selector	)) {
				targetActionPair.perform(selector, with: self)
			}
		}

	}
}
