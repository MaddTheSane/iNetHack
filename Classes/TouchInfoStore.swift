//
//  TouchInfoStore.swift
//  iNetHack
//
//  Created by C.W. Betts on 10/3/15.
//  Copyright 2015 Dirk Zimmermann. All rights reserved.
//

//  This file is part of iNetHack.
//
//  iNetHack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 2 of the License only.
//
//  iNetHack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iNetHack.  If not, see <http://www.gnu.org/licenses/>.

import UIKit

class TouchInfoStore : NSObject {
	private var currentTouchInfos = Dictionary<NSValue, TouchInfo>()
	
	var singleTapTimestamp: TimeInterval = 0
	
	var count: Int {
		return currentTouchInfos.count
	}
	
	func storeTouches(_ touches: Set<UITouch>) {
		for t in touches {
			let ti = TouchInfo(touch: t)
			let k = NSValue(nonretainedObject: t)
			currentTouchInfos[k] = ti
		}
	}
	
	func touchInfoForTouch(_ t: UITouch) -> TouchInfo? {
		let k = NSValue(nonretainedObject: t)
		return currentTouchInfos[k]
	}
	
	func removeTouches(_ touches: Set<UITouch>) {
		for t in touches {
			let k = NSValue(nonretainedObject: t)
			currentTouchInfos.removeValue(forKey: k)
		}
	}
}
