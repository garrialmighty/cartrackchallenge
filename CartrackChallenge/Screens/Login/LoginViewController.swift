//
//  LoginViewController.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/20/21.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var rememberButton: UIButton!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var countryPickerView: UIPickerView!
    private var viewModel = LoginViewModel(authenticator: Room.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    @IBAction private func login() {
        viewModel.authenticate()
    }
    
    @IBAction private func toggleRememberMe() {
        viewModel.willRemember.toggle()
        
        if #available(iOS 13.0, *) {
            let image = viewModel.willRemember ? UIImage(systemName: "checkmark.square")  : UIImage(systemName: "square")
            rememberButton.setImage(image, for: .normal)
        } else {
        let icon = viewModel.willRemember ? "☑️" : "⬜️"
            rememberButton.setTitle(icon, for: .normal)
        }
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func viewModel(_ viewModel: LoginViewModel, didEncounterError error: Error) {
        let alert = UIAlertController(title: "Unknown Error",
                                      message: "Unexpected error occurred. Please try again or contact support",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    func viewModel(_ viewModel: LoginViewModel, didLogin isAuthenticated: Bool) {
        if isAuthenticated {
            NotificationCenter.default.post(name: .loggedIn, object: nil)
        } else {
            let redColor = UIColor.red.cgColor
            usernameTextField.layer.borderColor = redColor
            passwordTextField.layer.borderColor = redColor
            
            let alert = UIAlertController(title: "Invalid Credentials",
                                          message: "Kindly double-check your username and password and try again",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // reset borders
        let blackColor = UIColor.black.cgColor
        usernameTextField.layer.borderColor = blackColor
        passwordTextField.layer.borderColor = blackColor
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedString = text.replacingCharacters(in: textRange, with: string)
            
            // only pass required data to view model
            if textField == usernameTextField {
                viewModel.username = updatedString
            } else if textField == passwordTextField {
                viewModel.password = updatedString
            }
            
            let hasValidFields = viewModel.hasValidFields
            
            // update login button state depending if the user had valid inputs
            loginButton.isEnabled = hasValidFields
            
            UIView.animate(withDuration: 0.4) { [unowned self] in
                self.countryLabel.alpha = hasValidFields ? 1.0 : 0.0
                self.countryPickerView.alpha = hasValidFields ? 1.0 : 0.0
            }
        }
        
        return true
    }
}

// MARK: - UIPickerViewDelegate
extension LoginViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedCountry = viewModel.countries[row]
    }
}

// MARK: - UIPickerViewDataSource
extension LoginViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.countries.count
    }
}
