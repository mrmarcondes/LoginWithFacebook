//
//  ViewController.swift
//  LoginWithFacebook
//
//  Created by Marco Rojo on 03/02/17.
//  Copyright © 2017 Marco Rojo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if FBSDKAccessToken.current() != nil {
      returnUserData()
    } else {
      let loginButton = FBSDKLoginButton()
      loginButton.center = view.center
      loginButton.readPermissions = ["email", "public_profile"]
      view.addSubview(loginButton)
      let faceBookLoginManger = FBSDKLoginManager()
      
      
      faceBookLoginManger.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
        //result is FBSDKLoginManagerLoginResult
        if (error != nil) {
          print("error is \(error)")
        }
        if (result?.isCancelled)! {
          //handle cancelations
        }
        if (result?.grantedPermissions.contains("email"))! {
          self.returnUserData()
        }
      })
    }
  }
  
  func returnUserData() {
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, gender, last_name, location, picture.type(large)"])
    
    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        // Process error
        print("Error: \(error)")
      }
      else
      {
        print("the access token is \(FBSDKAccessToken.current().tokenString)")
        
        var accessToken = FBSDKAccessToken.current().tokenString
        var graph = result! as! Dictionary<String, Any>
        var facebookProfileUrl = "http://graph.facebook.com/\(graph["id"]!)/picture?type=large"
        print("fetched user: \(result!)")
        print(facebookProfileUrl)
        
      }
    })
  }
}
