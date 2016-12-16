//
//  DMath.swift
//  iNetHack
//
//  Created by C.W. Betts on 12/19/15.
//
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

import Foundation
import CoreGraphics

private func DMath_VDIST(_ v1: CGPoint, _ v2: CGPoint) -> CGFloat {
	return sqrt((v2.x-v1.x)*(v2.x-v1.x)+(v2.y-v1.y)*(v2.y-v1.y))
}

@objc enum DMathDirection : Int {
	case Invalid = -1
	
	case Up = 0
	case UpRight
	case Right
	case DownRight
	case Down
	case DownLeft
	case Left
	case UpLeft
}

class DMath: NSObject {
	private let stdDistance: CGFloat
	private let directions: [CGPoint]
	
	class func normalizedPoint(_ ps: CGPoint) -> CGPoint {
		var p = ps
		let length = sqrt(p.x*p.x + p.y*p.y)
		p.x /= length;
		p.y /= length;
		return p
	}
	
	override init() {
		var tmpDirections = [CGPoint]()
		
		tmpDirections.append(CGPoint(x: 0, y: 1))
		tmpDirections.append(DMath.normalizedPoint(CGPoint(x: 1, y: 1)))
		tmpDirections.append(CGPoint(x: 1, y: 0))
		tmpDirections.append(DMath.normalizedPoint(CGPoint(x: 1, y: -1)))
		tmpDirections.append(CGPoint(x: 0, y: -1))
		tmpDirections.append(DMath.normalizedPoint(CGPoint(x: -1, y: -1)))
		tmpDirections.append(CGPoint(x: -1, y: 0))
		tmpDirections.append(DMath.normalizedPoint(CGPoint(x: -1, y: 1)))
		directions = tmpDirections
		stdDistance = DMath_VDIST(tmpDirections[DMathDirection.Up.rawValue],tmpDirections[DMathDirection.UpRight.rawValue])/2
		
		super.init()
	}
	
	@objc(directionFromVector:) func directionFrom(vector p: CGPoint) -> DMathDirection {
		// DMathDirection.Up to DMathDirection.UpLeft
		for i in 0...7 {
			let d = DMath_VDIST(directions[i], p)
			if fabs(d) <= stdDistance {
				return DMathDirection(rawValue: i)!
			}
		}
		
		return .Invalid
	}
}
