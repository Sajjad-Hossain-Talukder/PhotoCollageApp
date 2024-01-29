//
//  CollageViewController.swift
//  CollagePhoto
//
//  Created by Xotech on 29/01/2024.
//

import UIKit

class CollageViewController: UIViewController {
    
    var receivedData : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let image = receivedData {
            print("imageFound did ")
        }

    }
    

    @IBAction func collageButtonTapped(_ sender: UIButton) {
        print("CollageButtonTapped - "  )
        if let image = receivedData {
            print("imageFound did taaped ")
        }
    }
    

}
