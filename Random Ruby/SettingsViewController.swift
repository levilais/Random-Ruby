//
//  SettingsViewController.swift
//  Random Ruby
//
//  Created by Levi on 10/7/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

//        let loginButton = FBSDKLoginButton()
//        let x = CGFloat(view.center.x)
//        let y = CGFloat(view.center.y + view.frame.height / 2 - loginButton.frame.height - 32)
//        loginButton.center = CGPoint(x: x, y: y)
//        loginButton.readPermissions = ["public_profile","email"]
//        view.addSubview(loginButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "howToCell", for: indexPath) as! HowToTableViewCell
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "facebookCell", for: indexPath) as! facebookTableViewCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = CGFloat()
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == 1 {
            rowHeight = (facebookTableViewCell().textLabel?.frame.height)! + #imageLiteral(resourceName: "facebookGetHelpButton").size.height
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("user has cancelled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: [
                    "fields": "email,name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            if let userDeets = result {
                                print(userDeets)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }

}
