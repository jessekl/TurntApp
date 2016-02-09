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
        if FBSDKAccessToken.currentAccessToken() != nil{
            print("logged in")
            performSegueWithIdentifier("toInitView", sender: self )

            
        }
        else{
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        
        loginButton.readPermissions=["user_friends","public_profile","email"]
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //save user data locally, fb_id
        performSegueWithIdentifier("toInitView", sender: self )
        let _ = initialLoad()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
   }
