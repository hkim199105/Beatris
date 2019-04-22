//
//  Commons.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
