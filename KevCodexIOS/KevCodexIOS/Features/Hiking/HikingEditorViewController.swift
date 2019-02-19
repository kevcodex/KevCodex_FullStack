//
//  HikingEditorViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/13/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol HikingEditorViewControllerDelegate: class {
    func shouldRemoveDismissButton() -> Bool
    
    func hikingEditorViewController(_ hikingEditorViewController: HikingEditorViewController, didSubmitFor hike: Hike?, withBody body: Hike.UpdateBody)
    
    func hikingEditorViewControllerDidPressDismiss(_ hikingEditorViewController: HikingEditorViewController)
}

final class HikingEditorViewController: UIViewController {
    
    var hike: Hike?
    
    weak var delegate: HikingEditorViewControllerDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var hikeTimeTextField: UITextField!
    @IBOutlet weak var elevationGainTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var imagePathTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillTextFields()
        
        scrollView.keyboardDismissMode = .onDrag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        registerNotifications()
        
        dismissButton.setBackgroundImage(IconFactory.imageOfCrossIcon(), for: .normal)
        
        if let shouldRemove = delegate?.shouldRemoveDismissButton(),
            shouldRemove {
            dismissButton.removeFromSuperview()
        }
    }
    
    private func prefillTextFields() {
        
        guard let hike = hike else {
            return
        }
        
        titleTextField.text = hike.title
        descriptionTextView.text = hike.description
        locationTextField.text = hike.location
        distanceTextField.text = String(hike.distance)
        hikeTimeTextField.text = String(hike.hikingTime)
        elevationGainTextField.text = String(hike.elevationGain)
        difficultyTextField.text = hike.difficulty
        imagePathTextField.text = hike.imageURLString
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

extension HikingEditorViewController {
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let distanceDouble: Double? = {
            guard let distance = distanceTextField.text else {
                return nil
            }
            return Double(distance)
        }()
        
        let hikeTimeDouble: Double? = {
            guard let hikeTime = hikeTimeTextField.text else {
                return nil
            }
            return Double(hikeTime)
        }()
        
        let elevationGainInt: Int? = {
            guard let elevationGain = elevationGainTextField.text else {
                return nil
            }
            return Int(elevationGain)
        }()
        
        let body = Hike.UpdateBody(title: titleTextField.text,
                                   location: locationTextField.text,
                                   distance: distanceDouble,
                                   hikingTime: hikeTimeDouble,
                                   elevationGain: elevationGainInt,
                                   difficulty: difficultyTextField.text,
                                   description: descriptionTextView.text,
                                   imageURLString: imagePathTextField.text)

        delegate?.hikingEditorViewController(self, didSubmitFor: hike, withBody: body)
    }
    
    @IBAction func didPressDismissButton(_ sender: UIButton) {
        delegate?.hikingEditorViewControllerDidPressDismiss(self)
    }
}

// MARK: - Touches
extension HikingEditorViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

// MARK: - Keyboard Methods
extension HikingEditorViewController {
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

extension HikingEditorViewController: ActivityIndicatorPresenter {}

extension HikingEditorViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Hiking"
    }
}
