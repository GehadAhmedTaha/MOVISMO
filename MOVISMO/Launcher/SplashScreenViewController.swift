//
//  SplashScreenViewController.swift
//  MOVISMO
//
//  Created by Ahmed Mokhtar on 4/23/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var splashLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.alpha = 0
        camera.alpha = 0
        splashLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: {
            self.logo.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.camera.alpha = 1
            }, completion: { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.splashLabel.alpha = 1
                })
            })
        }
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
