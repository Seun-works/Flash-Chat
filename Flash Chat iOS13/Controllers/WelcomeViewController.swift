//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var characterIndex = 0
        titleLabel.text = ""
        let introText = "⚡️FlashChat"
        for letter in introText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(characterIndex), repeats: false) { timer  in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
            
        }
    }
    

}
