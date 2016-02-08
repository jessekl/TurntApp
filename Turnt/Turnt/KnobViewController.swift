//
//  KnobViewController.swift
//  Turnt
//
//  Created by Jesse Lurie on 2/6/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//

import UIKit
import SnappingStepper
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Alamofire
class KnobViewController: UIViewController{
    
    @IBOutlet weak var num: UILabel!
    var stepper = SnappingStepper(frame: CGRectMake(0, 0, 350, 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the stepper like any other UIStepper. For example:
        //
         stepper.continuous   = true
         stepper.autorepeat   = true
         stepper.wraps        = false
         stepper.minimumValue = 0
         stepper.maximumValue = 10
         stepper.stepValue    = 1
        
        stepper.symbolFont           = UIFont(name: "TrebuchetMS-Bold", size: 20)
        stepper.symbolFontColor      = UIColor.whiteColor()
        stepper.backgroundColor      = UIColor.blackColor()
        stepper.thumbWidthRatio      = 0.7
        
        stepper.thumbText            = "TurnT"
        stepper.thumbFont            = UIFont(name: "TrebuchetMS-Bold", size: 20)
        stepper.thumbBackgroundColor = UIColor.blueColor()
        stepper.thumbTextColor       = UIColor.whiteColor()
        
        stepper.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        stepper.center = self.view.center
        // If you don't want using the traditional `addTarget:action:` pattern you can use
        // the `valueChangedBlock`
        // snappingStepper.valueChangeBlock = { (value: Double) in
        //    println("value: \(value)")
        // }
        
        self.view.addSubview(stepper)
    }
    
    @IBAction func mapTap(sender: AnyObject) {
        performSegueWithIdentifier("toMapFromActivity", sender: self )
    }
    func valueChanged(sender: AnyObject) {
        // Retrieve the value: stepper.value
        num.text = "\(stepper.value)"
    }
    func GetActivities(){
        let data = NSUserDefaults.standardUserDefaults().objectForKey("friends") as! NSArray
        let postsEndpoint: String = "http://songathon.xyz/api/activities"
        let newPost = ["fb_id": data[0]["id"]]
        Alamofire.request(.POST, postsEndpoint, parameters: newPost, encoding: .JSON)
            .responseJSON { response in
                do {
                    if let _ = NSString(data:response.data!, encoding: NSUTF8StringEncoding) {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        let acts = jsonDictionary["result"] as! String
                        print(acts)
//                        NSUserDefaults.standardUserDefaults().setObject(result["id"], forKey: "user_id")
//                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                } catch {
                    print("bad things happened")
                }
        }
    }
}