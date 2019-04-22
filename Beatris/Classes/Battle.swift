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
    var mBeatrisViewController:BeatrisViewController
    
    required init(mVC:BeatrisViewController) {
        mBeatrisViewController = mVC
        self.Status = battleStatus.over
        self.Score = 0
        self.Speed = 1
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLineDestroyed(_:)), name: NSNotification.Name(rawValue: "LineDestroyed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onBattleStatusChanged(_:)), name: NSNotification.Name(rawValue: "BattleStatusChanged"), object: nil)
    }
    
    @objc func onLineDestroyed(_ mNotification:Notification) {
        if let lines = mNotification.userInfo?["lines"] as? Int {
            updateScore(add: 50 * 2 ^^ lines)
        }
    }
    
    @objc func onBattleStatusChanged(_ mNotification:Notification) {
        if let mBattleStatus = mNotification.userInfo?["battleStaus"] as? battleStatus {
            updateBattleStatus(mBattleStatus: mBattleStatus)
        }
    }
    
    func updateBattleStatus(mBattleStatus: battleStatus) {
        self.Status = mBattleStatus
        switch mBattleStatus {
        case .play:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartBattle"), object: nil)
            break
        case .pause:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PauseBattle"), object: nil)
            break
        case .over:
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
