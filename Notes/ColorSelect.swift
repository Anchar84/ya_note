//
//  ColorSelect.swift
//  Notes
//
//  Created by user on 14.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

@IBDesignable
class ColorSelect: UIView {
    
    @IBInspectable var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (isSelected) {
            let sRect = CGRect(x: rect.width * 0.65, y: 3, width: rect.width * 0.3, height: rect.height * 0.3)
            drawSelect(sRect)
        }
    }
    
    private func drawSelect(_ rect: CGRect) {
        let round = UIBezierPath(ovalIn: rect)
        round.lineWidth = 2
        let color = UIColor.black
        color.setStroke()
        round.stroke()
        
        let lines = UIBezierPath()
        let p1 = CGPoint(x: rect.minX + rect.width * 0.8, y: rect.height*0.2)
        let p2 = CGPoint(x: rect.minX + rect.width * 0.4, y: rect.height*0.9)
        let p3 = CGPoint(x: rect.minX + rect.width * 0.1, y: rect.height * 0.5)
        
        lines.move(to: p1)
        lines.addLine(to: p2)
        lines.addLine(to: p3)
        
        lines.lineWidth = 2
        color.setStroke()
        lines.stroke()
    }
}
