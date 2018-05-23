//
//  MapitoTextField.swift
//  mapito
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class MapitoTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 0, green: 181/255, blue: 145/255, alpha: 1).cgColor
        var frameRect = self.frame;
        frameRect.size.height = 30;
        self.frame = frameRect;
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.backgroundColor = UIColor.clear;
        self.layer.masksToBounds = true
    }
}
