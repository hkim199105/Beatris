//
//  Block.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

enum blockType: UInt32 {
    case a  //ㅣ
    case b  //ㅗ
    case c  //ㄱ
    case d  //
    case e  //ㄱㄴ
    case f  //
    case g  //ㅁ
    
    private static let _count: blockType.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = blockType(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    static func randomBlockType() -> blockType {
        let rand = arc4random_uniform(_count)
        return blockType(rawValue: rand)!
    }
}

enum status {
    case moving
    case stopped
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
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
            self.color = UIColor(hex: 0xD26363)
            break
        case .b:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 2, y: 0))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.color = UIColor(hex: 0xD2A8AA)
            break
        case .c:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 2, y: 0))
            self.cells.append(CGPoint(x: 2, y: 1))
            self.color = UIColor(hex: 0x0E2A38)
            break
        case .d:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 0, y: 2))
            self.cells.append(CGPoint(x: 1, y: 2))
            self.color = UIColor(hex: 0x304753)
            break
        case .e:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.cells.append(CGPoint(x: 2, y: 1))
            self.color = UIColor(hex: 0xCF7E83)
            break
        case .g:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.cells.append(CGPoint(x: 1, y: 2))
            self.color = UIColor(hex: 0xF2E1C2)
            break
        case .f:
            self.cells.append(CGPoint(x: 0, y: 0))
            self.cells.append(CGPoint(x: 1, y: 0))
            self.cells.append(CGPoint(x: 0, y: 1))
            self.cells.append(CGPoint(x: 1, y: 1))
            self.color = UIColor(hex: 0x301623)
            break
        }
    }
    
    static func generate() -> Block {
        return Block(mBlocktype: .randomBlockType())
    }
    
    func moveLeft() {
        self.position.x = self.position.x - 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlock"), object: self)
    }
    
    func moveRight() {
        self.position.x = self.position.x + 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlock"), object: self)
    }
    
    func moveDown() {
        self.position.y = self.position.y + 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlock"), object: self)
    }
    
    func rotateLeft() {
        let blockCenter = centerPoint(self.cells)
        var minY:CGFloat = 0
        
        // rotate block
        for i in 0 ..< self.cells.count {
            cells[i] = rotatePoint(target: cells[i], aroundOrigin: blockCenter, byDegrees: 90)
            if minY > cells[i].y {
                minY = cells[i].y
            }
        }
        
        // prevent go reversely upward
        if minY < 0 {
            for i in 0 ..< self.cells.count {
                let tempPoint = cells[i]
                cells[i] = CGPoint(x: Int(tempPoint.x), y: Int(tempPoint.y - minY))
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlock"), object: self)
    }
    
    func rotateRight() {
        let blockCenter = centerPoint(self.cells)
        var minY:Int = 0
        
        // rotate block
        for i in 0 ..< self.cells.count {
            cells[i] = rotatePoint(target: cells[i], aroundOrigin: blockCenter, byDegrees: -90)
            if CGFloat(minY) > cells[i].y {
                minY = Int(cells[i].y.rounded())
            }
        }
        
        // prevent go reversely upward
        if minY < 0 {
            for i in 0 ..< self.cells.count {
                let tempPoint = cells[i]
                cells[i] = CGPoint(x: Int(tempPoint.x), y: Int(tempPoint.y) - minY)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlock"), object: self)
    }
    
    func centerPoint(_ target: [CGPoint]) -> CGPoint {
        var avgX:CGFloat = 0
        var avgY:CGFloat = 0
        
        for point in target {
            avgX = avgX + point.x
            avgY = avgY + point.y
        }
        
        avgX = avgX / CGFloat(target.count)
        avgY = avgY / CGFloat(target.count)
        
        return CGPoint(x: Int(avgX.rounded()), y: Int(avgY.rounded()))
    }
    
    func rotatePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = target.x - origin.x
        let dy = target.y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx)
        let newAzimuth = azimuth + byDegrees * CGFloat(Double.pi / 180.0) // convert it to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        
        return CGPoint(x: Int(x.rounded()), y: Int(y.rounded()))
    }
}
