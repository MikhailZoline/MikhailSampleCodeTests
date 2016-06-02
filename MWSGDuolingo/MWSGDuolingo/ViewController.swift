//
//  ViewController.swift
//  MWSGDuolingo
//
//  Created by Mikhail Zoline on 03/28/16.
//  Copyright © 2016 Duolingo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, alphabetGridDelegate{
    
    @IBOutlet weak var btnReset: UIBarButtonItem!
    let gridViewLeading:CGFloat = 10.0
    let gridViewTop:CGFloat = 100.0

    var  gridView:mwsb_AlphabetGridView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btnReset.enabled = false
        
        let screenWdith = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
      
        // Grid View contains all alphabet view
        gridView =  mwsb_AlphabetGridView(frame: CGRectZero)

        gridView!.delegate = self
        gridView!.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(gridView!)
        
        // Leading
        let horizontalConstraint = NSLayoutConstraint(item:gridView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant:gridViewLeading)
        self.view.addConstraint(horizontalConstraint)
        
        //TOP
        let verticalConstraint = NSLayoutConstraint(item:gridView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:gridViewTop)
        
        self.view.addConstraint(verticalConstraint)
        
        // Width
        let widthConstraint = NSLayoutConstraint(item:gridView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: screenWdith - 2*gridViewLeading )
        self.view.addConstraint(widthConstraint)
        
        //Height
        let heightConstraint = NSLayoutConstraint(item: gridView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: screenHeight - gridViewTop)
        self.view.addConstraint(heightConstraint)

        
              
    
    }
    
    @IBAction func btnResetPressed(sender: AnyObject)
    {
        gridView!.resetSelection()
        
        self.btnReset.enabled = false

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func allWordsFound()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Message", message: "Congrates! All Words are found ", preferredStyle: .Alert)
        //Create and add the Cancel action
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(okAction)
        
        self.btnReset.enabled = true

        self.presentViewController(actionSheetController, animated:true, completion:nil)
    }

    
}

