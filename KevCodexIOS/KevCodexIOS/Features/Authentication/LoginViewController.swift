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
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        usernameTextField.delegate = self
    }
}

// MARK: - Text Field Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        delegate?.loginViewController(self, didLogin: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension LoginViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Authentication"
    }
}
