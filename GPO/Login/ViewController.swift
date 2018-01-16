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

class ViewController: UIViewController {
    
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

        if (isInternetAvailable()) {
            print("good")
            WebService.logIn(login, password)
            
        } else {
            showNotification("Отсутствует подключение к интернету")
        }
        

    }
    
    func connectToServer() {
        let body = [
            "grant_type" : "password",
            "username" : login,
            "password" : password
        ]
        let headers = [
            "Authorization" : "Basic ZGV2OnRlc3Q=",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        self.showActivityIndicatory(uiView: self.view, actInd: self.actInd)
        Alamofire.request("http://codesurvey.r-mobile.pro/api/token", method: .post, parameters: body, headers: headers).responseJSON { (responseObject) in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                if (resJson["error_description"] == "The user name or password is incorrect.") {
                    self.showNotification("Неверный логин и/или пароль")
                    self.actInd.stopAnimating()
                    if let viewWithTag = self.view.viewWithTag(100) {
                        viewWithTag.removeFromSuperview()
                    }
                }
                if (resJson["access_token"] != JSON.null ) {
                    
                    self.userDefaults.setValue(resJson["access_token"].string, forKey: "access_token")
                    self.actInd.stopAnimating()
                    if let viewWithTag = self.view.viewWithTag(100) {
                        viewWithTag.removeFromSuperview()
                    }
                    self.performSegue(withIdentifier: "StartApp", sender: nil)
                }
            }
            if responseObject.result.isFailure {
                let error : NSError = responseObject.result.error! as NSError
                print(error)
                self.showNotification("Ошибка подключения")
            }
        }
    }
    
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
    
    @IBOutlet weak var logInButton: UIButton!
    
  
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
