//
//  IOSViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/01/2021.
//

import UIKit

class IOSViewController: BaseViewController{
 
 
    @IBAction func keyPressed(_ sender: UIButton) {
        keyboardInteraction(key: sender.tag, pressed: true)
    }
    
    @IBAction func keyReleased(_ sender: UIButton) {
        keyboardInteraction(key: sender.tag, pressed: false)
    }
    
 
    
 
}



