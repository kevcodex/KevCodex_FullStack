//
//  HikingEditorViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/13/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol HikingEditorViewControllerDelegate: class {
    func hikingEditorViewController(_ hikingEditorViewController: HikingEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody, completion: @escaping () -> Void)
}


final class HikingEditorViewController: UIViewController {
    
    var project: Project?
    
    weak var delegate: HikingEditorViewControllerDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: CustomTextView!
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
        descriptionTextView.text = project.description
        imagePathTextField.text = project.imageURLString
        callToActionTextField.text = project.callToActionLink
        
        if let sortOrder = project.sortOrder {
            sortOrderTextField.text = String(sortOrder)
        }
    }
}

extension HikingEditorViewController {
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
        
        delegate?.hikingEditorViewController(self, didSubmitFor: project, withBody: body) { [weak self] in
            self?.hideActivityIndicator()
        }
    }
}

// MARK: - Touches
extension HikingEditorViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

extension HikingEditorViewController: ActivityIndicatorPresenter {}

extension HikingEditorViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Hiking"
    }
}
