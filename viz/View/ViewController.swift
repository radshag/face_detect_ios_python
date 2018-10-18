//
//  ViewController.swift
//  viz
//
//  Created by Dov Goldberg on 17/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let faceDetectionService: FaceDetectionServicing = FaceDetectionService.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loadImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        else {
            return
        }
        
        expressionLabel.text = "Detecting Faces"
        imageView.image = image
        
        guard
            let data = UIImageJPEGRepresentation(image, 0.6)
        else {
            return
        }
        
        faceDetectionService.detectFaces(imageData: data) { faceModel in
            
            guard
                let faceModel = faceModel,
                let facerect = faceModel.faceRect,
                let cgImage = self.imageView.image?.fixOrientation().cgImage
                else {
                    self.expressionLabel.text = "no faces found"
                    return
            }
            
            self.expressionLabel.text = faceModel.faceExpression
            
            if let croppedImage = cgImage.cropping(to: facerect) {
                let image = UIImage.init(cgImage: croppedImage)
                UIView
                    .transition(with: self.imageView,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: {
                                    self.imageView.image = image
                                },
                                completion: nil
                )
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
}

