//
//  BeatrisViewController.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class BeatrisViewController: UIViewController {

    @IBOutlet var overBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overBtn.addTarget(self, action: #selector(finishGame), for: .touchUpInside)
    }
    
    @objc func finishGame() {
        self.dismiss(animated: true)
    }
}
