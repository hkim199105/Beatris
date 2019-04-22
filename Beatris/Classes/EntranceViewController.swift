//
//  EntranceViewController.swift
//  Beatris
//
//  Created by hkim on 2019. 4. 22..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class EntranceViewController: UIViewController {

    @IBAction func playSingleBtnOnClicked(_ sender: Any) {
        let beatrisVC = self.storyboard?.instantiateViewController(withIdentifier: "beatrisVC")
        self.present(beatrisVC!, animated: true)
    }
    
    @IBAction func playWithBtnOnClicked(_ sender: Any) {
        let mAlert = UIAlertController(title: nil, message: "Under Construction...", preferredStyle: .alert)
        mAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(mAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
