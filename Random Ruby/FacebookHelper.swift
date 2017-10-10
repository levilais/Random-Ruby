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
    
    func shareOnFB(vc: UIViewController) {
        let url = URL(string: "fbauth2://")
        if UIApplication.shared.canOpenURL(url!) {
            let screen = UIScreen.main
            if let window = UIApplication.shared.keyWindow {
                UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0)
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let photo: FBSDKSharePhoto = FBSDKSharePhoto()
                photo.image = image
                photo.isUserGenerated = false
                
                let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
                content.photos = [photo]
                
                let dialog: FBSDKShareDialog = FBSDKShareDialog()
                dialog.fromViewController = vc
                dialog.shareContent = content
                dialog.mode = FBSDKShareDialogMode.shareSheet
                dialog.show()
                print("tried shareSheet")
            }
        } else {
            let alert = UIAlertController(title: "Facebook App Missing", message: "Please download the Facebook App from the App Store and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "App Store", style: .default, handler: { (action) in
                if let facebookLink: URL = URL(string: "itms-apps://itunes.apple.com/us/app/facebook/id284882215?mt=8") {
                    UIApplication.shared.open(facebookLink)
                }
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
