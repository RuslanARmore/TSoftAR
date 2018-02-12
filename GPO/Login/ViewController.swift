//
//  LoginViewController.swift
//  CSM
//
//  Created by Руслан Ахриев on 20.05.17.
//  Copyright © 2017 Руслан Ахриев. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration
import MaterialComponents.MaterialSnackbar


struct AccessToken : Decodable {
    let expires: String
    let issued: String
    let access_token: String
    let expires_in: Int
    let token_type: String
    let user_name: String
    enum CodingKeys : String, CodingKey {
        case expires = ".expires"
        case issued = ".issued"
        case access_token
        case expires_in
        case token_type
        case user_name
    }
}

struct ErrorPassword : Decodable {
    let error : String
    let error_description : String
}

class ViewController: UIViewController {
    var webService = WebService()
    var parser = JSONParser()
    var result : AnyObject!
    let userDefaults = UserDefaults.standard
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()

    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    var login : String {
        set {
            self.login = loginTF.text!
        }
        get {
            return self.loginTF.text!
        }
    }
    
    var password : String {
        set {
            self.password = passwordTF.text!
        }
        get {
            return self.passwordTF.text!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.showActivityIndicatory(uiView: self.view, actInd: self.actInd)
        let url = "http://codesurvey.r-mobile.pro/api/token"
        let body = [
            "grant_type" : "password",
            "username" : login,
            "password" : password
        ]
        let headers = [
            "Authorization" : "Basic ZGV2OnRlc3Q=",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        if (isInternetAvailable()) {
            
            webService.postMethod(url, body, headers, completionBlock: { (response) in
                let decoder = JSONDecoder()
                do {
                    let access = try decoder.decode(AccessToken.self, from: response!)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(access.access_token, forKey: "access_token")
                        if let viewWithTag = self.view.viewWithTag(100) {
                            viewWithTag.removeFromSuperview()
                        }
                        self.performSegue(withIdentifier: "StartApp", sender: nil)
                    }
                } catch {
                    do {
                        let wrongPassword = try decoder.decode(ErrorPassword.self, from: response!)
                        DispatchQueue.main.async {
                            print(wrongPassword.error_description)
                            self.showNotification("Неверный логин и/или пароль")
                            self.actInd.stopAnimating()
                            if let viewWithTag = self.view.viewWithTag(100) {
                                viewWithTag.removeFromSuperview()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            })
        } else {
            showNotification("Отсутствует подключение к интернету")
        }
    }
    

    @IBOutlet weak var logInButton: UIButton!
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showNotification(_ messageToWrite : String) {
        let message = MDCSnackbarMessage()
        message.text = messageToWrite
        MDCSnackbarManager.show(message)
    }
  
    func showActivityIndicatory(uiView: UIView, actInd : UIActivityIndicatorView) {
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.tag = 100
        container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.center = loadingView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.color = UIColor.white
        
        
        container.addSubview(loadingView)
        container.addSubview(actInd)
        
        
        uiView.addSubview(container)
       
        
        actInd.startAnimating()
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
