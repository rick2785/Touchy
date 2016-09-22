//
//  AuthenticationVC.swift
//  Touchy
//
//  Created by Rickey Hrabowskie on 9/22/16.
//  Copyright © 2016 Rickey Hrabowskie. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func useTouchIDBtnWasPressed(_ sender: AnyObject) {
        let authenticationContext = LAContext()
        var error: NSError?
        
        // Evaluating the policy
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {   // & = in/out parameter to modify that variable
            
            // Touch ID, navigating to success VC, handling errors
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Only humans allowed. Sorry, no dogs. 🐶", reply: { (success, error) in
                
                if success {    // Navigate to success VC
                    self.navigateToAuthenicatedVC()
                } else {
                    if let error = error as? NSError {
                        // Display an error of a specific type
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
            })
        } else {
            showAlertViewForNoBiometrics()
            return
        }
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message: String) {
        showAlertWithTitle(title: "Error", message: message)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts"
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
    func navigateToAuthenicatedVC() {
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "LoggedInVC") {
            DispatchQueue.main.async {  // Does navigation on main thread while touchID thinks on background thread
                self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
        }
    }
    
    func showAlertViewForNoBiometrics() {
        showAlertWithTitle(title: "Error", message: "This device does not have a Touch ID sensor.")
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

