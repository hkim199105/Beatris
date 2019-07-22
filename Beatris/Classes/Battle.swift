//
//  Battle.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

enum battleStatus {
    case play
    case pause
    case over
}

class Battle: NSObject {
    var Score:Int
    var Speed:Int
    var Status:battleStatus
    var mBattleFieldView:BattleField
    var Timer:CADisplayLink?
    var TimerIdx = 0
    
    required init(mBFV:BattleField) {
        self.Status = battleStatus.play
        self.Score = 0
        self.Speed = 1
        mBattleFieldView = mBFV
        
        super.init()
        
        self.Timer = CADisplayLink(target: self, selector: #selector(self.update))
        self.Timer?.preferredFramesPerSecond = 60        // 60fps
        self.Timer?.isPaused = false
        self.Timer?.add(to: .current, forMode: .default)
        
        self.mBattleFieldView.mBattle = self
    }
    
    @objc func update() {
        self.TimerIdx = self.TimerIdx + 1
        if TimerIdx % 60 == 1 {
            mBattleFieldView.update()
        }
    }
    
    @objc func onLineDestroyed(_ numLines:Int) {
        updateScore(add: 50 * 2 ^^ numLines)
    }
    
    func updateBattleStatus(_ mBattleStatus: battleStatus) {
        self.Status = mBattleStatus
        switch mBattleStatus {
        case .play:
            self.Timer?.isPaused = false
            break
        case .pause:
            self.Timer?.isPaused = true
            break
        case .over:
            self.Timer?.isPaused = true
            self.Timer?.remove(from: .current, forMode: .default)
            self.Timer?.invalidate()
            self.Timer = nil
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "overBattle"), object: nil)
            break
        }
    }
    
    func updateScore(add: Int) {
        self.Score += add
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateScore"), object: self.Score)
        
        updateSpeed()
    }
    
    func updateSpeed() {
        self.Speed = Score / 50
    }
}
