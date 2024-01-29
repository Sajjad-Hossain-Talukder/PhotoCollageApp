//
//  VerticalResultViewController.swift
//  CollagePhoto
//
//  Created by Xotech on 29/01/2024.
//

import UIKit

class VerticalResultViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var receivedData : UIImage!
    override func viewDidLoad() {

        super.viewDidLoad()
        
        if let res = receivedData {
            imageView.image = res
        }
       
    }
    
    
    
    @IBAction func saveImageTapped(_ sender: UIButton) {
        saveImageToPhotoLibrary( imageView.image!)
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image to photo library:", error.localizedDescription)
        } else {
            print("Image saved successfully to photo library")
        }
    }
    

}
