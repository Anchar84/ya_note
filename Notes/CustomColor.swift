//
//  CustomColor.swift
//  Notes
//
//  Created by user on 14.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CustomColor: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        colorPreview.layer.borderWidth = 1
        colorPreview.layer.borderColor = UIColor.gray.cgColor
    }

    @IBOutlet weak var alphaValue: UISlider!
    @IBOutlet weak var colorPiker: HSBColorPicker!
    @IBOutlet weak var colorPreview: UIView!
    
    var onClose: ((_ color: UIColor?) -> Void)?
    private var color: UIColor?
    
    @IBAction func goBack(_ sender: Any) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        guard let closeHandler = onClose else {
            return
        }
        closeHandler(color)
    }
    
    @IBAction func alphaChange(_ sender: UISlider) {
        guard let c = color else {
            return
        }
        c.withAlphaComponent(CGFloat(alphaValue.value))
        
        colorPreview.backgroundColor = c
        colorPreview.setNeedsDisplay()
    }
    
    
    @IBAction func colorSelect(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: colorPiker)
        color = colorPiker.getColorAtPoint(point: point)
        
        color?.withAlphaComponent(CGFloat(alphaValue.value))
        
        colorPreview.backgroundColor = color
        colorPreview.setNeedsDisplay()
    }

}
