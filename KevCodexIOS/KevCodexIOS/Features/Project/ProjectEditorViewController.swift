//
//  ProjectEditorViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/19/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol ProjectEditorViewControllerDelegate: class {
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody)
}

final class ProjectEditorViewController: UIViewController {
    var project: Project?
    
    weak var delegate: ProjectEditorViewControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var imagePathTextField: UITextField!
    @IBOutlet weak var callToActionTextField: UITextField!
    @IBOutlet weak var sortOrderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
        scrollView.keyboardDismissMode = .onDrag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        registerNotifications()
    }
    
    private func setupTextFields() {
        
        guard let project = project else {
            return
        }
        
        titleTextField.text = project.title
        
        descriptionTextView.text = project.description

        imagePathTextField.text = project.imageURLString

        callToActionTextField.text = project.callToActionLink

        if let sortOrder = project.sortOrder {
            sortOrderTextField.text = String(sortOrder)
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        unregisterNotifications()
    }
}

extension ProjectEditorViewController {
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let project = project else {
            return
        }
        
        let sortOrderInt: Int? = {
            guard let sortOrder = sortOrderTextField.text else {
                return nil
            }
            return Int(sortOrder)
        }()
        
        let body = Project.UpdateBody(title: titleTextField.text,
                                      imageURLString: imagePathTextField.text,
                                      description: descriptionTextView.text,
                                      callToActionLink: callToActionTextField.text,
                                      sortOrder: sortOrderInt)
        
        showActivityIndicator(title: "Loading")
        
        delegate?.projectEditorViewController(self, didSubmitFor: project, withBody: body)
    }
}

// MARK: - Keyboard Methods
extension ProjectEditorViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
}

extension ProjectEditorViewController: ActivityIndicatorPresenter {}

extension ProjectEditorViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
