//
//  AppDelegate.swift
//  MWSGDuolingo
//
//  Created by Mikhail Zoline on 03/28/16.
//  Copyright © 2016 Duolingo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var charactersGridArray :[AnyObject]?
    var wordLocations:[String : [(Int , Int)]] = Dictionary()
    var sourceWord:String?
    var allFoundedWords:[String] = Array()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
       // UIApplication.makeTextWritingDirectionLeftToRight("asdfasd asdf as f")
        
        // Read data from file

        self.readLocalData()
        
        self.callAPI() // Parsing is not working since text file contains multiple json objects and they are not seperated by any delimiter
        
        
        return true
    }

        func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK:- Get API Call
    func callAPI()
    {
        let url = NSURL(string:"https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt")
    
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            
         let resultStr = NSString(data:data!, encoding:
                NSNonLossyASCIIStringEncoding)
            
        let resultData = resultStr?.dataUsingEncoding(NSNonLossyASCIIStringEncoding)
            
            do {
                // Will return an object or nil if JSON decoding fails
                let resultObj =  try NSJSONSerialization.JSONObjectWithData(resultData!, options:NSJSONReadingOptions.AllowFragments)
                
                print(resultObj)
                
            } catch  let error as NSError {
                debugPrint(error)
            }
            
            
        }.resume()
    }
    
    // MARK:- Loal data reading

    func readLocalData()
    {
        
        if let path = NSBundle.mainBundle().pathForResource("document", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                    
                    print(jsonResult)
                    
                    self.parseData(jsonResult as! Dictionary<String ,AnyObject>)
                    
                } catch {}
            } catch {}
        }
        
        
    }
    
   // MARK: - Data Parsing
    func parseData(result:Dictionary<String ,AnyObject>)
    {
        charactersGridArray  = result["character_grid"] as? [AnyObject]
        
        let wordLocatiions =   result["word_locations"]
        
        sourceWord =  result["word"] as? String
        print(wordLocatiions!.allKeys)
        
        
        for (_ ,key) in wordLocatiions!.allKeys.enumerate()
        {
            
            let word = wordLocatiions![key as! String]
            
            print(word)
            
            var locationIndexArray:[(Int , Int)] = Array()
            
            let fullIndexesArray = key.componentsSeparatedByString(",")
            
            var i = 0
            while i < fullIndexesArray.count{
                var locationIndex:(Int ,Int) = (-1,-1)
                
                locationIndex.0 = Int(fullIndexesArray[i])!
                
                locationIndex.1 = Int(fullIndexesArray[i + 1])!
                
                locationIndexArray.append(locationIndex)
                
                i += 2
            }
            
            self.wordLocations[word! as! String] = locationIndexArray
        }
    }


}

