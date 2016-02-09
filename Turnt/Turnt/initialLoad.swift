//
//  initialLoad.swift
//  Turnt
//
//  Created by Jesse Lurie on 2/8/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import Alamofire

class initialLoad{
    
    init(){
        UserData()
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
