//
//  ImageViewController.swift
//  Notes
//
//  Created by user on 22.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imgViews = [UIImageView]()
    let imagePicker = UIImagePickerController()
    var imgCounter = 0
    
    @IBOutlet weak var scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for name in ["img1", "img2", "img3", "img4", "img5"] {
            let imgView = UIImageView(image: UIImage(named: name))
            imgView.contentMode = .scaleToFill
            imgViews.append(imgView)
            scroll.addSubview(imgView)
        }
        
        navigationItem.title = "Галерея"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(_:)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (index, iView) in imgViews.enumerated() {
            iView.frame.size = scroll.frame.size
            iView.frame.origin.x = scroll.frame.width * CGFloat(index)
            iView.frame.origin.y = 0
            imgCounter += 1
        }
        let w = scroll.frame.width * CGFloat(imgViews.count)
        scroll.contentSize = CGSize(width: w, height: scroll.frame.height)
    }
    
    @objc func addClicked (_ sender: Any) {
        selectImage()
    }

}

extension ImageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectImage(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let imgView = UIImageView(image: pickedImage)
            imgView.contentMode = .scaleToFill
            imgViews.append(imgView)
            scroll.addSubview(imgView)
            
            imgView.frame.size = scroll.frame.size
            imgView.frame.origin.x = scroll.frame.width * CGFloat(imgCounter)
            imgView.frame.origin.y = 0
            
            imgCounter += 1
            let w = scroll.frame.width * CGFloat(imgCounter)
            scroll.contentSize = CGSize(width: w, height: scroll.frame.height)

            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

