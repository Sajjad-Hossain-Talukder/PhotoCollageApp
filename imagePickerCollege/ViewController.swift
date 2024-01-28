//
//  ViewController.swift
//  imagePickerCollege
//
//  Created by Xotech on 28/01/2024.
//

import UIKit

import PhotosUI

class ViewController: UIViewController{
    
    var imageArray = [UIImage]()
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var photoCollectionFlow: UICollectionViewFlowLayout!
    var combo : UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        photoCollection.register(UINib(nibName: "ProjectViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectViewCell")
        photoCollection.collectionViewLayout = photoCollectionFlow
        photoCollectionFlow.minimumLineSpacing = 0
        photoCollectionFlow.minimumInteritemSpacing = 0 
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            if let destVC = segue.destination as? ResultViewController {
                destVC.receivedData = combo
            }
        }
    }

    @IBAction func addImageTapped(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        
        let phPickerVC = PHPickerViewController(configuration: config)
        
        phPickerVC.delegate = self
        
        self.present(phPickerVC, animated: true)
        
    }
    
    @IBAction func collegeImageTapped(_ sender: UIButton) {
        self.combo = self.combineImages(self.imageArray)
    }
    func combineImages(_ images: [UIImage]) -> UIImage? {
       
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for image in images {
            totalWidth += image.size.width
            if image.size.height > maxHeight {
                maxHeight = image.size.height
            }
        }
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: totalWidth, height: maxHeight), false, 0.0)
        
        var currentX: CGFloat = 0
        

        for image in images {
            let rect = CGRect(x: currentX, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            currentX += image.size.width
        }
        

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return combinedImage
    }

    
}


extension ViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true )
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {object,error in
                if let image = object as? UIImage {
                    self.imageArray.append(image)
                }
                DispatchQueue.main.async {
                    self.photoCollection.reloadData()
                   
                }
            })
        }
        
       
        
        
    }
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "ProjectViewCell", for: indexPath) as! ProjectViewCell
        
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sajjad- ")
        print(imageArray[indexPath.row].size)
        
        var h = imageArray[indexPath.row].size.height / 8
        var w = imageArray[indexPath.row].size.width / 8
        
        
        return CGSize(width: w, height: h)
    }
    
}

