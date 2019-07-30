//
//  ViewController.swift
//  Notes
//
//  Created by user on 12.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var destroyDate: UIDatePicker!
    @IBOutlet weak var destroyDateHeight: NSLayoutConstraint!
    
    @IBOutlet weak var whiteColor: ColorSelect!
    @IBOutlet weak var redColor: ColorSelect!
    @IBOutlet weak var greenColor: ColorSelect!
    @IBOutlet weak var customColor: ColorSelect!
    
    private var gradientLayer: CAGradientLayer?
    var noteIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        noteText.layer.borderWidth = 1
        noteText.layer.borderColor = UIColor.gray.cgColor
        
        whiteColor.layer.borderWidth = 1
        whiteColor.layer.borderColor = UIColor.black.cgColor
        redColor.layer.borderWidth = 1
        redColor.layer.borderColor = UIColor.black.cgColor
        greenColor.layer.borderWidth = 1
        greenColor.layer.borderColor = UIColor.black.cgColor
        customColor.layer.borderWidth = 1
        customColor.layer.borderColor = UIColor.black.cgColor
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.colors = [UIColor.red.cgColor,    UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientLayer!.locations = [0.0, 0.6, 0.8]
        gradientLayer!.frame = customColor.bounds
        customColor.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noteIndex = selectedNode
        if noteIndex < 0 {return}
        let note = myNotebook.getNotes[noteIndex]
        noteTitle?.text = note.title
        noteText?.text = note.content
        whiteColor.isSelected = false
        redColor.isSelected = false
        greenColor.isSelected = false
        customColor.isSelected = false
        if (note.color == whiteColor.backgroundColor) {
            whiteColor.isSelected = true
        } else if (note.color == redColor.backgroundColor) {
            redColor.isSelected = true
        } else if (note.color == greenColor.backgroundColor) {
            greenColor.isSelected = true
        } else {
            customColor.isSelected = true
            customColor.backgroundColor = note.color
        }
        if note.selfDestructionDate != nil {
            destroyDateHeight.constant = 150
            destroyDate.date = note.selfDestructionDate ?? Date()
        }
    }

    @IBAction func showDate(_ sender: UISwitch) {
        destroyDate.isHidden = !sender.isOn
        if destroyDate.isHidden {
            destroyDateHeight.constant = 0
        } else {
            destroyDateHeight.constant = 150
        }
    }
    
    
    @IBAction func greenColorSelect(_ sender: Any) {
        whiteColor.isSelected = false
        redColor.isSelected = false
        greenColor.isSelected = true
        customColor.isSelected = false

    }
    
    @IBAction func redColorSelect(_ sender: Any){
        whiteColor.isSelected = false
        redColor.isSelected = true
        greenColor.isSelected = false
        customColor.isSelected = false
    }
    
    @IBAction func customColorSelect(_ sender: Any) {
        whiteColor.isSelected = false
        redColor.isSelected = false
        greenColor.isSelected = false
        customColor.isSelected = true
        
        let customColorView = CustomColor()
        customColorView.onClose = { (color: UIColor?) in
            guard let c = color else {return}
            self.gradientLayer!.removeFromSuperlayer()
            self.customColor.backgroundColor = c
            print("color selected")
            self.customColor.setNeedsDisplay()
        }
        present(customColorView, animated: true, completion: nil)
    }
    
    @IBAction func whiteColorSelect(_ sender: Any) {
       whiteColor.isSelected = true
       redColor.isSelected = false
       greenColor.isSelected = false
       customColor.isSelected = false
    }
    
    @IBAction func saveNote(_ sender: UIButton) {
        guard let title = noteTitle.text else {return}
        guard let text = noteText.text else {return}
        var color: UIColor = UIColor.white
        if greenColor.isSelected {color = greenColor?.backgroundColor ?? color}
        if redColor.isSelected {color = redColor?.backgroundColor ?? color}
        if customColor.isSelected {color = customColor?.backgroundColor ?? color}
        var date: Date? = destroyDate.date
        if destroyDate.isHidden {
            date = nil
        }
        var uid = UUID().uuidString
        if noteIndex >= 0 {
            let note = myNotebook.getNotes[noteIndex]
            uid = note.uid
            myNotebook.remove(with: uid)
        }
        myNotebook.add(Note(uid: uid, title: title, content: text, color: color, selfDestructionDate: date, importance: .important))
        performSegue(withIdentifier: "unwindToMainWithSegue", sender: nil)
    }
}

