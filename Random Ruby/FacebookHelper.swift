//
//  FacebookHelper.swift
//  Random Ruby
//
//  Created by Levi on 10/7/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class FacebookHelper {
    func loginFacebookAction(sender: UIViewController) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: sender) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result as Any)
                }
            })
        }
    }
    
//    func postPhoto(sender: UIButton) {
//        let screen = UIScreen.main
//        
//        if let window = UIApplication.shared.keyWindow {
//            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0)
//            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            print("window was created")
//            
//            let photo: FBSDKSharePhoto = FBSDKSharePhoto()
//            photo.image = image
//            photo.isUserGenerated = false
//            
//            let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
//            content.photos = [photo]
//            
//            let dialog: FBSDKShareDialog = FBSDKShareDialog()
//            dialog.fromViewController = sender
//            dialog.shareContent = content
//            dialog.mode = FBSDKShareDialogMode.shareSheet
//            dialog.show()
//            
//        } else {
//            print("didn't work - should be showing alert")
//            let alert = UIAlertController(title: "Something went wrong", message: "Random Ruby was unable to capture a screenshot to post to Facebook.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            sender.present(alert, animated: true, completion: nil)
//        }
//    }
}
