//
//  mwsb-AnAlphabelView.swift
//  MWSGDuolingo
//
//  Created by Mikhail Zoline on 03/28/16.
//  Copyright © 2016 Duolingo. All rights reserved.
//

import UIKit



class mwsb_AnAlphabelView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var metaDataModel:mwsb_AnAlphabetMetaDataModel?
    
    
    var lblAlphabet:UILabel?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        //  self.setup()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        
    }
    
    
     init (frame : CGRect , alphabetName:String) {
        super.init(frame : frame)
        
        //  self.setup()
        
        
        lblAlphabet = UILabel()
        lblAlphabet!.text = alphabetName
        lblAlphabet!.backgroundColor = UIColor.clearColor()
        
        
        self.addSubview(lblAlphabet!)
        
        lblAlphabet!.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.backgroundColor = UIColor(red:240/255.0, green:244/255.0, blue: 255/255.0, alpha:1.0)
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        
        self.setUpConstraints()
        
    }
    
    func setUpConstraints()
    {
        //
        let horizontalConstraint = NSLayoutConstraint(item: lblAlphabet!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: lblAlphabet!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(verticalConstraint)
        

    }
    
   
}
