//
//  mwsb-AlphabetGridView.swift
//  MWSGDuolingo
//
//  Created by Mikhail Zoline on 03/28/16.
//  Copyright © 2016 Duolingo. All rights reserved.
//

import UIKit

protocol alphabetGridDelegate: NSObjectProtocol {
    func allWordsFound()
}

class mwsb_AlphabetGridView: UIView {
    

    let alphabetViewWidht:Int = 50
    let alphabetViewHeight:Int = 50
    
    var delegate:alphabetGridDelegate?
    
    let selectedViewColor:UIColor =  UIColor.purpleColor() // color for view when user touch and move to another view
    
    let foundedWordColor:UIColor = UIColor(red:143/255.0, green:178/255.0, blue: 255/255.0, alpha:1.0)
    
    var startingView:mwsb_AnAlphabelView?  // first view selected when user starts dragging
    
    var currentSelectedView:mwsb_AnAlphabelView?   // Current selected view
    
    var allSelectedViews:[mwsb_AnAlphabelView] = Array()  // it contails all unique view when user mvoe from one posiontn to other.
    
    var allViews:[mwsb_AnAlphabelView] = Array()  // This contains all the alphabetview defined in grid based upn json data
    
    
    var allFoundWords:[String : [mwsb_AnAlphabelView]] = Dictionary();  // list of all the discovered words
    

    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        //Create Alphabet view UI
        self.createAlphabetViews()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        
    }
    
    // MARK: - UI Configuration
    
    
    func createAlphabetViews()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        for (i ,characters) in appDelegate.charactersGridArray!.enumerate()
        {
            let charcs:[String] = characters as! [String]
            for (j ,letter) in charcs.enumerate()
            {
                var constY = 0
                
                let alphabetView = mwsb_AnAlphabelView(frame:CGRectZero, alphabetName:letter)
                
                alphabetView.translatesAutoresizingMaskIntoConstraints = false
                
                let metaDataModel =   mwsb_AnAlphabetMetaDataModel()
                metaDataModel.currentIndex.0 = j
                metaDataModel.currentIndex.1 = i
                
                alphabetView.metaDataModel = metaDataModel
                
                
                self.addSubview(alphabetView)
                
                let constant:Int = j * alphabetViewWidht
                let horizontalConstraint = NSLayoutConstraint(item: alphabetView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant:CGFloat(constant))
                self.addConstraint(horizontalConstraint)
                
                constY = constY + i * alphabetViewHeight
                
                let verticalConstraint = NSLayoutConstraint(item: alphabetView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(constY))
                
                self.addConstraint(verticalConstraint)
                
                let widthConstraint = NSLayoutConstraint(item:alphabetView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(alphabetViewWidht))
                self.addConstraint(widthConstraint)
                
                let heightConstraint = NSLayoutConstraint(item: alphabetView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(alphabetViewHeight))
                self.addConstraint(heightConstraint)
                
                
                self.allViews.append(alphabetView)
                
            }
        }
    }
    
    
    // MARK: - Touch Events
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            if touch.view!.isKindOfClass(mwsb_AnAlphabelView) // if touch is inside alphabet view
            {
                let view = touch.view!
                view.backgroundColor = selectedViewColor // changing color of selected View
                startingView = view as? mwsb_AnAlphabelView
                currentSelectedView = view as? mwsb_AnAlphabelView
                self.allSelectedViews.append(currentSelectedView!)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            // do something with your currentPoin
            
            if let currentAlphabetView =  self.viewContainingCurrentPoint(currentPoint)
            {
                
                let startingViewX = self.startingView?.metaDataModel?.currentIndex.0
                let startingViewY = self.startingView?.metaDataModel?.currentIndex.1
                
                let currentViewX = currentAlphabetView.metaDataModel?.currentIndex.0
                let currentViewY = currentAlphabetView.metaDataModel?.currentIndex.1
                
                self.currentSelectedView = currentAlphabetView
                self.cleanColor() // clear all color befor user move to next location
                
                // Top To Bottom Condition
                if  startingViewX! == currentViewX! && startingViewY! < currentViewY!
                    
                {
                    self.allSelectedViews = self.getAllVerticalViewBetweenStartAndCurrentLocation()
                }
                    // Left to right condition
                else if  startingViewY! == currentViewY! && startingViewX! < currentViewX!
                {
                    self.allSelectedViews = self.getAllHorizontalViewBetweenStartAndCurrentLocation()
                }
                    //Diagnol top to bottom or left to right conditon
                else if  currentViewY! > startingViewY!  &&  currentViewX! > startingViewX!
                {
                    self.allSelectedViews = self.getAllDiagnolViewsBetweenStartAndCurrentLocation()
                }
                self.changeColor()   // highlight  all the views from start location to current locaiton by color
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            
            self.checkSelectedViewContainWordLocation()  // checking word conatin conditon
            self.allSelectedViews.removeAll()  // clean current selection
            self.changeColorForFoundedWords()  // Higligting founded words
            self.checkAllTheWordsFound()  // Cheking if all the words found than nofifiy user
        }
    }
    
    // MARK: - Private functions
    
    // Functunality : To check if user selected views contain word location .

    private func checkSelectedViewContainWordLocation()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let allSelectedViewsArrray = Array(self.allSelectedViews)
        var wordFound:Bool = true
        for  (_ , value) in   appDelegate.wordLocations.enumerate()
        {
            wordFound  = true
            let wordLocationArray:[(Int , Int)] = value.1
            if wordLocationArray.count == self.allSelectedViews.count
            {
                for (index ,aLocation ) in wordLocationArray.enumerate()
                {
                    let aSelectedView:mwsb_AnAlphabelView =  allSelectedViewsArrray[index]
                    
                    if aLocation.0 == aSelectedView.metaDataModel!.currentIndex.0 &&
                        aLocation.1 == aSelectedView.metaDataModel!.currentIndex.1
                    {
                        
                    }else
                    {
                        wordFound = false
                        break;
                    }
                }
                if wordFound
                {
                    self.allFoundWords[value.0] = allSelectedViewsArrray
                    
                    appDelegate.allFoundedWords.append(value.0)
                    break
                }
                
            }else
            {
                wordFound = false
            }
        }
        
        if !wordFound
        {
            for (_ ,aView) in allSelectedViewsArrray.enumerate()
            {
                aView.backgroundColor = UIColor(red:240/255.0, green:244/255.0, blue: 255/255.0, alpha:1.0)
            }
        }
        
    }
    
    // Functunality : To check if all the words are found

    private func checkAllTheWordsFound()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if appDelegate.wordLocations.count == self.allFoundWords.count
        {
            print("All Words Found ")
            
            
            delegate?.allWordsFound()
 
            
            //Present the AlertController
        }
    }
    
   // Functunality : To find the alphabet view which contains user touch location

    private func viewContainingCurrentPoint(currentPoint:CGPoint) -> mwsb_AnAlphabelView?
    {
        for (_ , view) in self.allViews.enumerate()
        {
            if view.frame.contains(currentPoint)
            {
                return view
            }
        }
        return nil
    }
    
    // Functunality : To return all Horizontal(left to right) views based upon user movment

    private  func getAllHorizontalViewBetweenStartAndCurrentLocation() -> [mwsb_AnAlphabelView]
    {
        let startLocaiotn = self.startingView?.metaDataModel!.currentIndex
        let currentLocation = self.currentSelectedView?.metaDataModel!.currentIndex
        var hViews:[mwsb_AnAlphabelView] = Array()
        for i in startLocaiotn!.0 ... currentLocation!.0
        {
            let filteredItems =   self.allViews.filter({m in
                
                if let xIndex = m.metaDataModel?.currentIndex.0 , yIndex = m.metaDataModel?.currentIndex.1
                {
                    if xIndex == i && yIndex == startLocaiotn!.1
                    {
                        return true
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            })
            hViews.append(filteredItems.first!)
        }
        
        return hViews
    }
    
    // Functunality : To return all vertical(top to bottom) views based upon user movment

    private func getAllVerticalViewBetweenStartAndCurrentLocation() -> [mwsb_AnAlphabelView]
    {
        let startLocaiotn = self.startingView?.metaDataModel!.currentIndex
        let currentLocation = self.currentSelectedView?.metaDataModel!.currentIndex
        
        var vViews:[mwsb_AnAlphabelView] = Array()
        
        for i in startLocaiotn!.1 ... currentLocation!.1
        {
            let filteredItems =   self.allViews.filter({m in
                
                if let xIndex = m.metaDataModel?.currentIndex.0 , yIndex = m.metaDataModel?.currentIndex.1
                {
                    if xIndex == startLocaiotn!.0 && yIndex == i
                    {
                        return true
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            })
            vViews.append(filteredItems.first!)
        }
        
        return vViews
    }
    
    // Functunality : To return all diagnol view based upon user movment

    private  func getAllDiagnolViewsBetweenStartAndCurrentLocation() -> [mwsb_AnAlphabelView]
    {
        let startLocaiotn = self.startingView?.metaDataModel!.currentIndex
        let currentLocation = self.currentSelectedView?.metaDataModel!.currentIndex
        var vViews:[mwsb_AnAlphabelView] = Array()
        vViews.append(self.startingView!)
        
        var index:Int = 1
        for _ in startLocaiotn!.1 ..< currentLocation!.1
        {
            let filteredItems =   self.allViews.filter({m in
                
                if let xIndex = m.metaDataModel?.currentIndex.0 , yIndex = m.metaDataModel?.currentIndex.1
                {
                    if xIndex == startLocaiotn!.0 + index  && yIndex == startLocaiotn!.1 + index
                    {
                        return true
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            })
            index += 1
            
            if filteredItems.count > 0
            {
                vViews.append(filteredItems.first!)
            }
        }
        return vViews
    }
    
    // Functunality : To higlight founded words with different color

    private  func changeColorForFoundedWords()
    {
        
        for (_, key) in allFoundWords.keys.enumerate()
        {
            let views = self.allFoundWords[key]! as [mwsb_AnAlphabelView]
            
            for (_, aView) in  views.enumerate()
            {
                aView.backgroundColor = foundedWordColor
            }
            
        }
    }
    
    // Functunality : To move color back to orgional color after selection over if word is not matching

    private func cleanColor()
    {
        for (_, aView) in self.allSelectedViews.enumerate()
        {
            aView.backgroundColor = UIColor(red:240/255.0, green:244/255.0, blue: 255/255.0, alpha:1.0)
        }
    }
    
    // Functunality : To change all selected views color to highlight them
    private  func changeColor()
    {
        for (_, aView) in self.allSelectedViews.enumerate()
        {
            aView.backgroundColor = selectedViewColor
        }
    }
    
     func resetSelection()
    {
        for (_, key) in allFoundWords.keys.enumerate()
        {
            let views = self.allFoundWords[key]! as [mwsb_AnAlphabelView]
            
            for (_, aView) in  views.enumerate()
            {
                aView.backgroundColor = UIColor(red:240/255.0, green:244/255.0, blue: 255/255.0, alpha:1.0)
            }
            
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        self.allFoundWords.removeAll()
        appDelegate.allFoundedWords.removeAll()
    }
}
