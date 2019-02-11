//
//  LoginViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/8/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewController(_ loginViewController: LoginViewController, didLogin username: String)
}

final class LoginViewController: UIViewController {
    
    struct Credentials {
        var username: String
        var password: String
        
        func isValid() -> Bool {
            guard !username.isEmpty, !password.isEmpty else {
                return false
            }
            
            return true
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    private var credentials = Credentials(username: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}

// MARK: - Actions
extension LoginViewController {
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        guard credentials.isValid() else {
            return
        }
        
        
    }
}

// MARK: - Text Field Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == usernameTextField,
            let text = textField.text {
            
            credentials.username = text
            
        } else if textField == passwordTextField,
            let text = textField.text {
            
            credentials.password = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension LoginViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Authentication"
    }
}
