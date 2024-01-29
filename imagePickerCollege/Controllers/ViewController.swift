//
//  ViewController.swift
//  imagePickerCollege
//
//  Created by Xotech on 28/01/2024.
//

import UIKit

import PhotosUI

class ViewController: UIViewController{
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    var combo : UIImage! = nil
    var imageArray = [UIImage]()
    
    @IBOutlet weak var collageNavigation: NSLayoutConstraint!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var photoCollectionFlow: UICollectionViewFlowLayout!

    @IBOutlet weak var verticalButton: UIButton!
    
    @IBOutlet weak var horizontalButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        photoCollection.register(UINib(nibName: "ProjectViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectViewCell")
        photoCollection.collectionViewLayout = photoCollectionFlow
        photoCollectionFlow.minimumLineSpacing = 1
        photoCollectionFlow.minimumInteritemSpacing = 1
        
        collageNavigation.constant = 0
        
    }
    
    //MARK: - Haptic FeedBack
    
    func addHaptic(){
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
    
    //MARK: - TEST PHASE
    
    @IBAction func touchDown(_ sender: UIButton) {
        addHaptic()
        sender.adjustsImageWhenHighlighted = false
        UIView.animate(withDuration: 0.2 , animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @IBAction func touchUP(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2 , animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            if let destVC = segue.destination as? ResultViewController {
                destVC.receivedData = combo
            }
        } else if segue.identifier == "gogo" {
            if let destVC = segue.destination as? VerticalResultViewController {
                destVC.receivedData = combo
            }
        }
    }
    
    func addCollageButton(){
        let newHeight = (imageArray.count <= 1) ?  0 : view.layer.frame.height * 99 / 896
        UIView.animate(withDuration: 0.7 ) {
            self.collageNavigation.constant = newHeight
            self.view.layoutIfNeeded()
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
        if sender == horizontalButton {
            combo = combineImagesHorizontally(imageArray)
            performSegue(withIdentifier: "go", sender: self)
        } else {
            combo = combineImagesVertically(imageArray)
            performSegue(withIdentifier: "gogo", sender: self)
        }
    }
    
    
    func combineImagesHorizontally(_ images: [UIImage]) -> UIImage? {
       
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

    
    
    func combineImagesVertically(_ images: [UIImage]) -> UIImage? {
       
        var maxWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for image in images {
            totalHeight += image.size.height
            if image.size.width > maxWidth {
                maxWidth = image.size.width
            }
        }
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: totalHeight), false, 0.0)
        
        var currentY: CGFloat = 0
        

        for image in images {
            let rect = CGRect(x: 0, y: currentY, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            currentY += image.size.height
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
                    self.addCollageButton()
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
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(cancelItem), for: .touchUpInside)
        
        return cell
    }
    
    @objc func cancelItem(sender: UIButton ) {
        imageArray.remove(at: sender.tag)
        addCollageButton()
        photoCollection.reloadData()
        
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("sajjad- ")
        //print(imageArray[indexPath.row].size)
        
        let h = imageArray[indexPath.row].size.height / 8 - 1
        let w = imageArray[indexPath.row].size.width / 8 - 1
        
        
        return CGSize(width: w, height: h)
    }
    
}



