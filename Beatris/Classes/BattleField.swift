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
    case center
}

class BattleField: UIView {
    
    var width = 10
    var height = 20
    var gap = 0
    var currentBlock: Block?
    var field:[[UIColor]]
    var bgColor = UIColor.white
    var mBattle: Battle?
    
    // storyboard에서 사용하기 위한 필수 init
    required init?(coder aDecoder: NSCoder) {
        field = [[UIColor]](repeating: Array(repeating: bgColor,count: self.height ), count: self.width)
        
        for y in stride(from: self.height-1, to: self.height-5, by: -1) {
            for x in 0..<self.width {
                if x != 3 {
                    self.field[x][y] = UIColor.black
                }
            }
        }
        
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveBlockLeft), name: NSNotification.Name(rawValue: "moveBlockLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveBlockRight), name: NSNotification.Name(rawValue: "moveBlockRight"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotateBlockLeft), name: NSNotification.Name(rawValue: "rotateBlockLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotateBlockRight), name: NSNotification.Name(rawValue: "rotateBlockRight"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropBlock), name: NSNotification.Name(rawValue: "dropBlock"), object: nil)
        generateBlock()
    }
    
    override init(frame: CGRect) {
        field = [[UIColor]](repeating: Array(repeating: bgColor, count: self.width ), count: self.height)
        super.init(frame: frame)
        
    }
    
    fileprivate func drawCell(x: CGFloat, y: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat, color: UIColor) {
        let block = CGRect(x: x,
                           y: y,
                           width: cellWidth,
                           height: cellHeight)
        color.set()
        UIBezierPath(roundedRect: block, cornerRadius: 0).fill()
    }
    
    override func draw(_ rect: CGRect) {
        let cellWidth = (rect.width - CGFloat(gap + self.width)) / CGFloat(self.width)
        let cellHeight = (rect.height - CGFloat(gap + self.height)) / CGFloat(self.height)
        
        // draw field and stacked blocks
        for x in 0..<self.width {
            for y in 0..<self.height {
                drawCell(x: CGFloat(x + self.gap) + CGFloat(x) * cellWidth,
                         y: CGFloat(y + self.gap) + CGFloat(y) * cellHeight,
                         cellWidth: CGFloat(cellWidth),
                         cellHeight: CGFloat(cellHeight),
                         color: self.field[x][y])
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
                     color: currentBlock.color)
        }
    }
    
    func update() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.down) == true {
            currentBlock.moveDown()
        } else {
            for cell in currentBlock.cells {
                let x = Int(cell.x + currentBlock.position.x)
                let y = Int(cell.y + currentBlock.position.y)
                if x >= 0 && x < field.count && y >= 0 && y < field[x].count {
                    field[x][y] = currentBlock.color
                }
            }
            
            generateBlock()
        }
        deleteLines()
        
        self.setNeedsDisplay()
    }
    
    func deleteLines() {
        var numFullLine = 0
        
        for y in stride(from: 0, to: self.height, by: 1) {
            var isFullLine = true
            
            // check if the line if full
            for x in 0..<self.width {
                if self.field[x][y] == self.bgColor {
                    isFullLine = false
                }
            }
            
            // delete the line(y) and drop upper lines
            if isFullLine == true {
                numFullLine = numFullLine + 1
                
                for mY in stride(from: y, to: 0, by: -1) {
                    for mX in 0..<self.width{
                        if mY == 0 {
                            self.field[mX][mY] = self.bgColor
                        } else {
                            self.field[mX][mY] = self.field[mX][mY-1]
                        }
                        self.setNeedsDisplay()
                    }
                }
            }
        }
        
        if numFullLine > 0 {
            self.mBattle?.onLineDestroyed(numFullLine)
        }
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
                if x >= 0 && x < field.count && y + 1 >= 0 && y + 1 < field[x].count {
                    if field[x][y + 1] != bgColor {
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
                if x - 1 >= 0 && x < field.count && y >= 0 && y < field[x].count {
                    if field[x - 1][y] != bgColor {
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
                if x + 1 >= 0 && x + 1 < field.count  && y >= 0 && y < field[x].count {
                    if field[x + 1][y] != self.bgColor {
                        return false
                    }
                }
                break
                
            case .up:
                break
                
            case .center:
                // reached wall
                if x < 0 {
                    return false
                }
                if x > self.width - 1 {
                    return false
                }
                
                // reached another block
                if x >= 0 && x < field.count  && y >= 0 && y < field[x].count {
                    if field[x][y] != self.bgColor {
                        return false
                    }
                }
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
        
        // check if game over
        if isAvailMove(.center) == false {
            self.mBattle?.updateBattleStatus(.over)
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func rotateBlockRight() {
        guard let currentBlock = self.currentBlock else { return }
        
        let befCells = NSArray(array:currentBlock.cells, copyItems: true)
        
        currentBlock.rotateRight()
        
        if isAvailMove(.center) == false {
            currentBlock.cells = NSArray(array:befCells as! [Any], copyItems: true) as! [CGPoint]
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func rotateBlockLeft() {
        guard let currentBlock = self.currentBlock else { return }
        
        let originalCells = NSArray(array:currentBlock.cells, copyItems: true)
        let originalPosition = CGPoint(x: currentBlock.position.x, y: currentBlock.position.y)
        var isMoved = false
        
        currentBlock.rotateLeft()
        
        // move block if there is no space but side
        for x in 0..<self.width {
            let mX = currentBlock.position.x
            let mY = currentBlock.position.y
            
            currentBlock.position = CGPoint(x: mX + CGFloat(x), y: mY)
            if isAvailMove(.center) == true {
                isMoved = true
                break
            }
            
            currentBlock.position = CGPoint(x: mX - CGFloat(x), y: mY)
            if isAvailMove(.center) == true {
                isMoved = true
                break
            }
        }
        
        // cancel rotate if there is no space neither side
        if isMoved == false {
            currentBlock.cells = NSArray(array:originalCells as! [Any], copyItems: true) as! [CGPoint]
            currentBlock.position = originalPosition
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func moveBlockRight() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.right) == true {
            currentBlock.moveRight()
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func moveBlockLeft() {
        guard let currentBlock = self.currentBlock else { return }
        
        if isAvailMove(.left) == true {
            currentBlock.moveLeft()
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func dropBlock() {
        guard let currentBlock = self.currentBlock else { return }
        
        while(isAvailMove(.down) == true) {
            currentBlock.moveDown()
            deleteLines()
            self.setNeedsDisplay()
        }
        
        self.update()
    }
}
