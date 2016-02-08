//
//  ViewController.swift
//  Turnt
//
//  Created by Jesse Lurie on 2/6/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
     let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        
        loginButton.readPermissions=["user_friends","public_profile","email"]
        self.view.addSubview(loginButton)
        loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //save user data locally, fb_id
        performSegueWithIdentifier("toInitView", sender: self )
        UserData()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    func UserData(){
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        meRequest.startWithCompletionHandler{(connection,result,err) -> Void in
            if err != nil {
                print(err)
            }
            else{
                print(result)
                let postsEndpoint: String = "http://songathon.xyz/api/create"
                let newPost = ["fb_id": result["id"]]
                NSUserDefaults.standardUserDefaults().setObject(result["id"], forKey: "user_id")
                NSUserDefaults.standardUserDefaults().synchronize()
                Alamofire.request(.POST, postsEndpoint, parameters: newPost, encoding: .JSON)
                    .responseJSON { response in
                        do {
                            if let _ = NSString(data:response.data!, encoding: NSUTF8StringEncoding) {
                                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                                let theuser = jsonDictionary["result"] as! String
                                print(theuser)                            }
                        } catch {
                            print("bad things happened")
                        }
                }
            }
        //save friends fb_ids to find all activitys and save 
            //array of lat,lon,title,
        let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler{(connection,result,error)-> Void in
            if error != nil{
                print(error)
            }
            else{
                NSUserDefaults.standardUserDefaults().setObject(result["data"], forKey: "friends")
                NSUserDefaults.standardUserDefaults().synchronize()

            }
        }
        }
    }
}
