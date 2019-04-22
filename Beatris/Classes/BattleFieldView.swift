//
//  BattleFieldView.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class BattleFieldView: UIView {
    
    var width = 10
    var height = 20
    var gap = 1
    
    // storyboard에서 사용하기 위한 필수 initr
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        let cellWidth = (rect.width - CGFloat(gap + self.width) + 1) / CGFloat(self.width)
        let cellHeight = (rect.height - CGFloat(gap + self.height) + 1) / CGFloat(self.height)
        
        for x in 0..<self.width {
            for y in 0..<self.height {
                let block = CGRect(x: CGFloat((x + self.gap)) + CGFloat(x) * cellWidth,
                                   y: CGFloat((y + self.gap)) + CGFloat(y) * cellHeight,
                                   width: CGFloat(cellWidth),
                                   height: CGFloat(cellHeight))
                UIBezierPath(roundedRect: block, cornerRadius: 3).fill()
            }
        }
    }
}
