//
//  BeatrisViewController.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class BeatrisViewController: UIViewController {

    @IBOutlet var btnOver: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var lblInfo: UILabel!
    @IBOutlet var lblScore: UILabel!
    @IBOutlet weak var mBattleFieldView: BattleField!
    var mBattle: Battle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnOver.addTarget(self, action: #selector(onClickBtnOver), for: .touchUpInside)
        self.btnPause.addTarget(self, action: #selector(onClickBtnPause), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(printBlockInfo(mNotification:)), name: NSNotification.Name(rawValue: "moveBlock"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteBattleView), name: NSNotification.Name(rawValue: "overBattle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(printScore(mNotification:)), name: NSNotification.Name(rawValue: "updateScore"), object: nil)
        
        let gesMoveBlock = UITapGestureRecognizer(target: self, action: #selector(moveBlock))
        gesMoveBlock.numberOfTouchesRequired = 1
        gesMoveBlock.numberOfTapsRequired = 1
        gesMoveBlock.cancelsTouchesInView = true
        gesMoveBlock.delaysTouchesBegan = false
        gesMoveBlock.delaysTouchesEnded = false
        self.view.addGestureRecognizer(gesMoveBlock)
        
        let gesRotateRight = UISwipeGestureRecognizer(target: self, action: #selector(rotateRight))
        gesRotateRight.direction = .right
        self.view.addGestureRecognizer(gesRotateRight)
        
        let gesRotateLeft = UISwipeGestureRecognizer(target: self, action: #selector(rotateLeft))
        gesRotateLeft.direction = .left
        self.view.addGestureRecognizer(gesRotateLeft)
        
        let gesDrop = UISwipeGestureRecognizer(target: self, action: #selector(drop))
        gesDrop.direction = .down
        self.view.addGestureRecognizer(gesDrop)
        
        self.mBattle = Battle(mBFV: mBattleFieldView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mBattle = nil
        
        super.viewWillDisappear(animated)
    }
    
    @objc func onClickBtnPause() {
        if self.mBattle?.Status == .pause {
            self.playBattle()
        } else if self.mBattle?.Status == .play {
            self.pauseBattle()
        }
    }
    
    @objc func onClickBtnOver() {
        overBattle()
    }
    
    func pauseBattle() {
        self.mBattle?.updateBattleStatus(.pause)
    }
    
    func playBattle() {
        self.mBattle?.updateBattleStatus(.play)
    }
    
    func overBattle() {
        self.mBattle?.updateBattleStatus(.over)
    }
    
    @objc func deleteBattleView() {
        self.dismiss(animated: true)
    }
    
    @objc func moveBlock (_ sender : UIPanGestureRecognizer) {
        let viewWidth = self.view.frame.width
        
        if sender.location(in: self.view).x <= viewWidth / 2 {
            print("move left")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlockLeft"), object: nil)
            
        } else {
            print("move right")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveBlockRight"), object: nil)
        }
    }
    
    @objc func rotateRight (_ sender : UISwipeGestureRecognizer) {
        print("rotate right")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rotateBlockRight"), object: nil)
    }
    
    @objc func rotateLeft (_ sender : UISwipeGestureRecognizer) {
        print("rotate left")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rotateBlockLeft"), object: nil)
    }
    
    @objc func drop (_ sender : UISwipeGestureRecognizer) {
        print("drop")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dropBlock"), object: nil)
    }
    
    @objc func printBlockInfo(mNotification: NSNotification) {
        if let mBlock = mNotification.object as? Block {
            var tempStr = "position.x: " + mBlock.position.x.description + "\nposition.y: " + mBlock.position.y.description
            for cell in mBlock.cells {
                tempStr = tempStr + "\nx: " + cell.x.description + "\ty: " + cell.y.description
            }
            self.lblInfo.text = tempStr
        }
    }
    
    @objc func printScore(mNotification: NSNotification) {
        if let mScore = mNotification.object as? Int {
            self.lblScore.text = "Score: " + String(mScore)
        }
    }
}
