//
//  Block.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

enum blockType {
    case a  //ㅣ
    case b  //ㅗ
    case c  //ㄱ
    case d  //
    case e  //ㄱㄴ
    case f  //
    case g  //ㅁ
}

enum status {
    case moving
    case stopped
}

class Block: NSObject {
    var position:CGPoint
    var color:UIColor
    var cells:[CGPoint]
    
    required init(mBlocktype: blockType) {
        self.position = CGPoint(x: 0, y: 0)
        cells = [CGPoint]()
        switch mBlocktype {
        case .a:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 2, y: 0))
            self.cells.append(CGPoint(x: 3, y: 0))
            self.color = UIColor.blue
            break
        case .b:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 2, y: 0))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.color = UIColor.red
            break
        case .c:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 2, y: 0))
            self.cells.append(CGPoint(x: 2, y: 1))
            self.color = UIColor.gray
            break
        case .d:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 0, y: 2))
            self.cells.append(CGPoint(x: 1, y: 2))
            self.color = UIColor.green
            break
        case .e:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.cells.append(CGPoint(x: 2, y: 1))
            self.color = UIColor.purple
            break
        case .g:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.cells.append(CGPoint(x: 1, y: 2))
            self.color = UIColor.orange
            break
        case .f:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.color = UIColor.yellow
            break
        }
    }
}
