//
//  ProjectEditorViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/13/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol ProjectEditorViewControllerDelegate: class {
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody, completion: @escaping () -> Void)
}


final class ProjectEditorViewController: UIViewController {
    
    var project: Project?
    
    weak var delegate: ProjectEditorViewControllerDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imagePathTextField: UITextField!
    @IBOutlet weak var callToActionTextField: UITextField!
    @IBOutlet weak var sortOrderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillTextFields()
        
    }
    
    private func prefillTextFields() {
        
        guard let project = project else {
            return
        }
        
        titleTextField.text = project.title
        descriptionTextField.text = project.description
        imagePathTextField.text = project.imageURLString
        callToActionTextField.text = project.callToActionLink
        
        if let sortOrder = project.sortOrder {
            sortOrderTextField.text = String(sortOrder)
        }
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
                                      description: descriptionTextField.text,
                                      callToActionLink: callToActionTextField.text,
                                      sortOrder: sortOrderInt)
        
        showActivityIndicator(title: "Loading")
        
        delegate?.projectEditorViewController(self, didSubmitFor: project, withBody: body) { [weak self] in
            self?.hideActivityIndicator()
        }
    }
}

// MARK: - Touches
extension ProjectEditorViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

extension ProjectEditorViewController: ActivityIndicatorPresenter {}

extension ProjectEditorViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
