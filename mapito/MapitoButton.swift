//
//  MapitoBlueButton.swift
//  mapito
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class MapitoButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        //@IBInspectable var backgroundColor: String?
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0, green: 181/255, blue: 145/255, alpha: 1)
        self.setTitleColor(UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1), for: UIControlState.normal)
        //Bleu
        //self.setTitleColor(UIColor(red: 0, green: 181/255, blue: 145/255, alpha: 1), for: UIControlState.normal)
        
        //Constraints
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 45)
        
        NSLayoutConstraint.activate([heightConstraint])
        
        // Shadows
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
}
