//
//  NethackYnFunction.swift
//  iNetHack
//
//  Created by C.W. Betts on 10/3/15.
//  Copyright 2009 Dirk Zimmermann. All rights reserved.
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

class NethackYnFunction : NSObject {
	let question: UnsafePointer<CChar>
	let choices: UnsafePointer<CChar>
	let defaultChoice: CChar
	var chosen = 0
	
	var choice: CChar {
		return choices[chosen];
	}
	
	init(question q: UnsafePointer<CChar>, choices ch: UnsafePointer<CChar>, defaultChoice c: CChar) {
		question = q
		choices = ch
		defaultChoice = c
		
		super.init()
	}
}
