//
//  LoginViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/8/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewController(_ loginViewController: LoginViewController, didLogin user: User)
}

final class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    // Activity conformance
    var activityIndicator = ActivityProgressHud()
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
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
        
        view.endEditing(true)
        
        guard credentials.isValid() else {
            return
        }
        
        showActivityIndicator(title: "Loading")
        
        AuthenticationWorker.login(with: credentials) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let user):
                strongSelf.delegate?.loginViewController(strongSelf, didLogin: user)
            case .failure(let error):
                print(error)
            }
            
            strongSelf.hideActivityIndicator()
        }
    }
}

// MARK: - Touches
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
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

extension LoginViewController: ActivityIndicatorPresenter {
}

extension LoginViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Authentication"
    }
}
