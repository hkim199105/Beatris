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
    var mBattleFieldView:BattleFieldView
    var Timer:CADisplayLink!
    var TimerIdx = 0
    
    required init(mBFV:BattleFieldView) {
        self.Status = battleStatus.play
        self.Score = 0
        self.Speed = 1
        mBattleFieldView = mBFV
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLineDestroyed(_:)), name: NSNotification.Name(rawValue: "LineDestroyed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onBattleStatusChanged(_:)), name: NSNotification.Name(rawValue: "BattleStatusChanged"), object: nil)
        
        self.Timer = CADisplayLink(target: self, selector: #selector(self.update))
        self.Timer.preferredFramesPerSecond = 60        // 60fps
        self.Timer.isPaused = false
        self.Timer.add(to: .current, forMode: .default)
    }
    
    @objc func update() {
        self.TimerIdx = self.TimerIdx + 1
        if TimerIdx % 60 == 1 {
            mBattleFieldView.update()
        }
    }
    
    @objc func onLineDestroyed(_ mNotification:Notification) {
        if let lines = mNotification.userInfo?["lines"] as? Int {
            updateScore(add: 50 * 2 ^^ lines)
        }
    }
    
    @objc func onBattleStatusChanged(_ mNotification:Notification) {
        if let mBattleStatus = mNotification.userInfo?["battleStaus"] as? battleStatus {
            updateBattleStatus(mBattleStatus)
        }
    }
    
    func updateBattleStatus(_ mBattleStatus: battleStatus) {
        self.Status = mBattleStatus
        switch mBattleStatus {
        case .play:
            self.Timer.isPaused = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartBattle"), object: nil)
            break
        case .pause:
            self.Timer.isPaused = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PauseBattle"), object: nil)
            break
        case .over:
            self.Timer.isPaused = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OverBattle"), object: nil)
            break
        }
    }
    
    func updateScore(add: Int) {
        self.Score += add
        updateSpeed()
    }
    
    func updateSpeed() {
        self.Speed = Score / 500
    }
}
