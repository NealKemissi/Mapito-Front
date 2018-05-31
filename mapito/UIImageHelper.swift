//
//  UIImageHelper.swift
//  mapito
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        // self.layer.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1) as! CGColor
    }
}

