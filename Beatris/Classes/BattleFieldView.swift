//
//  BattleFieldView.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

enum blockDirection {
    case up
    case down
    case left
    case right
}

class BattleFieldView: UIView {
    
    var width = 10
    var height = 20
    var gap = 1
    var currentBlock: Block?
    var field:[[Int]]
    
    // storyboard에서 사용하기 위한 필수 init
    required init?(coder aDecoder: NSCoder) {
        field = [[Int]](repeating: Array(repeating: 0,count: self.height ), count: self.width)
        
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveBlockLeft), name: NSNotification.Name(rawValue: "moveBlockLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveBlockRight), name: NSNotification.Name(rawValue: "moveBlockRight"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotateBlockLeft), name: NSNotification.Name(rawValue: "rotateBlockLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotateBlockRight), name: NSNotification.Name(rawValue: "rotateBlockRight"), object: nil)
        generateBlock()
    }
    
    override init(frame: CGRect) {
        field = [[Int]](repeating: Array(repeating: 0, count: self.width ), count: self.height)
        super.init(frame: frame)
        
    }
    
    fileprivate func drawCell(x: CGFloat, y: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat, color: UIColor) {
        let block = CGRect(x: x,
                           y: y,
                           width: cellWidth,
                           height: cellHeight)
        color.set()
        UIBezierPath(roundedRect: block, cornerRadius: 3).fill()
    }
    
    override func draw(_ rect: CGRect) {
        let cellWidth = (rect.width - CGFloat(gap + self.width) + 1) / CGFloat(self.width)
        let cellHeight = (rect.height - CGFloat(gap + self.height) + 1) / CGFloat(self.height)
        
        // draw field
        for x in 0..<self.width {
            for y in 0..<self.height {
                drawCell(x: CGFloat((x + self.gap)) + CGFloat(x) * cellWidth,
                         y: CGFloat((y + self.gap)) + CGFloat(y) * cellHeight,
                         cellWidth: CGFloat(cellWidth),
                         cellHeight: CGFloat(cellHeight),
                         color: UIColor.black)
            }
        }
        
        // draw stacked blocks
        for x in 0..<field.count {
            for y in 0..<field[x].count {
                if field[x][y] == 1 {
                    drawCell(x: CGFloat((x + self.gap)) + CGFloat(x) * cellWidth,
                             y: CGFloat((y + self.gap)) + CGFloat(y) * cellHeight,
                             cellWidth: CGFloat(cellWidth),
                             cellHeight: CGFloat(cellHeight),
                             color: UIColor.green)
                }
            }
        }
        
        // draw current block
        guard let currentBlock = self.currentBlock else { return }
        
        for cell in currentBlock.cells {
            let x = cell.x + currentBlock.position.x
            let y = cell.y + currentBlock.position.y
            
            drawCell(x: x + CGFloat(self.gap) + x * cellWidth,
                     y: y + CGFloat(self.gap) + y * cellHeight,
                     cellWidth: CGFloat(cellWidth),
                     cellHeight: CGFloat(cellHeight),
                     color: UIColor.orange)
        }
    }
    
    func update() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.down) {
            currentBlock.moveDown()
        } else {
            for cell in currentBlock.cells {
                let x = Int(cell.x + currentBlock.position.x)
                let y = Int(cell.y + currentBlock.position.y)
                if x >= 0 && x < field.count && y >= 0 && y < field[x].count {
                    field[x][y] = 1
                }
            }
            
            generateBlock()
        }
        
        self.setNeedsDisplay()
    }
    
    func isAvailMove(_ mBlockDirection:blockDirection) -> Bool {
        guard let currentBlock = self.currentBlock else { return false }
        
        for cell in currentBlock.cells {
            let x = Int(cell.x + currentBlock.position.x)
            let y = Int(cell.y + currentBlock.position.y)
            
            switch mBlockDirection {
            case .down:
                // reached wall
                if y >= self.height - 1 {
                    return false
                }
                
                // reached another block
                if x >= 0 && x < field.count && y + 1 >= 0 && y + 1 <= field[x].count {
                    if field[x][y + 1] == 1 {
                        return false
                    }
                }
                break
            case .left:
                // reached wall
                if x <= 0 {
                    return false
                }
                
                // reached another block
                if x - 1 >= 0 && x < field.count && y >= 0 && y <= field[x].count {
                    if field[x - 1][y] == 1 {
                        return false
                    }
                }
                break
            case .right:
                // reached wall
                if x >= self.width - 1 {
                    return false
                }
                
                // reached another block
                if x + 1 >= 0 && x + 1 < field.count  && y >= 0 && y <= field[x].count {
                    if field[x + 1][y] == 1 {
                        return false
                    }
                }
                break
            case .up:
                break
            }
        }
        
        return true
    }
    
    func generateBlock() {
        self.currentBlock = Block.generate()
        guard let currentBlock = self.currentBlock else { return }
        var maxX = CGFloat(0)
        var minX = CGFloat(0)
        var maxY = CGFloat(0)
        var minY = CGFloat(0)
        
        for cell in currentBlock.cells {
            if cell.x < minX { minX = cell.x }
            if cell.x > maxX { maxX = cell.x }
            if cell.y < minY { minY = cell.y }
            if cell.y > maxY { maxY = cell.y }
        }
        
        let blockWidth = maxX - minX
        let blockHeight = maxY - minY
        
        currentBlock.position.x = CGFloat(floor((CGFloat(self.width) - blockWidth) / 2))
        currentBlock.position.y = -blockHeight
        AudioServicesPlayAlertSound(1521)
        
        self.setNeedsDisplay()
    }
    
    @objc func rotateBlockRight() {
        guard let currentBlock = self.currentBlock else { return }
        
        currentBlock.rotateRight()
        
        self.setNeedsDisplay()
    }
    
    @objc func rotateBlockLeft() {
        guard let currentBlock = self.currentBlock else { return }
        
        currentBlock.rotateLeft()
        
        self.setNeedsDisplay()
    }
    
    @objc func moveBlockRight() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.right) {
            currentBlock.moveRight()
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func moveBlockLeft() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.left) {
            currentBlock.moveLeft()
        }
        
        self.setNeedsDisplay()
    }
}
