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
    @IBOutlet private weak var countryPickerView: UIPickerView!
    private var viewModel = LoginViewModel()
    
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
    func viewModel(_ viewModel: LoginViewModel, didLogin isAuthenticated: Bool) {
        print("is authed \(isAuthenticated)")
        if isAuthenticated {
            // TODO: navigate to user list screen
        } else {
            // TODO: show error
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedString = text.replacingCharacters(in: textRange, with: string)
            
            // only pass required data to view model
            if textField == usernameTextField {
                viewModel.username = updatedString
            } else if textField == passwordTextField {
                viewModel.password = updatedString
            }
            
            // update login button state depending if the user had valid inputs
            loginButton.isEnabled = viewModel.hasValidFields
            
            // TODO: animate country picker
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
