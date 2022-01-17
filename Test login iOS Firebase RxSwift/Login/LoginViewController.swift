//
//  LoginViewController.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 28/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var loginButton: CustomButton!
    
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginErrorLabel.isHidden = true
        // emailField.becomeFirstResponder()
        // passwordField.becomeFirstResponder()
        setBindings()
        setLoginButtonSubscription()
        setAuthenticationSubscription()
        setAuthenticationErrorSubscription()
        
    }
    
    private func setEmailFieldColor(valid: Bool) {
        emailField.layer.borderWidth = valid ? 1 : 0
        emailField.layer.cornerRadius = 8
        emailField.layer.borderColor = valid ? #colorLiteral(red: 0.01251956106, green: 1, blue: 0, alpha: 1) : .none
    }
    
    private func setPasswordFieldColor(valid: Bool) {
        passwordField.layer.borderWidth = valid ? 1 : 0
        passwordField.layer.cornerRadius = 8
        passwordField.layer.borderColor = valid ? #colorLiteral(red: 0.01251956106, green: 1, blue: 0, alpha: 1) : .none
    }
    
    private func clearFields() {
        setEmailFieldColor(valid: false)
        setPasswordFieldColor(valid: false)
        emailField.text = ""
        passwordField.text = ""
    }
    
    @IBAction func backToMainMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController {
    private func setBindings() {
        emailField.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordField.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        viewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
        viewModel.isEmailValid().subscribe { [weak self] valid in
            self?.setEmailFieldColor(valid: valid)
        }.disposed(by: disposeBag)
        
        viewModel.isPasswordValid().subscribe { [weak self] valid in
            self?.setPasswordFieldColor(valid: valid)
        }.disposed(by: disposeBag)
    }
    
    private func setLoginButtonSubscription() {
        loginButton.rx.tap
            .withLatestFrom(viewModel.isValid())
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let email = self?.emailField.text, let password = self?.passwordField.text else {
                    fatalError("Erreur email et mot de passe")
                }
                self?.viewModel.authenticate(with: email, and: password)
            }.disposed(by: disposeBag)
    }
    
    private func setAuthenticationSubscription() {
        viewModel.loginObservable.subscribe { [weak self] uid in
            guard let userViewController = self?.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {
                fatalError("Le ViewController n'est pas détecté dans le storyboard")
            }
            
            userViewController.uid = uid
            userViewController.modalPresentationStyle = .fullScreen
            self?.present(userViewController, animated: true, completion: nil)
            self?.clearFields()
            self?.loginErrorLabel.isHidden = true
        } onError: { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    private func setAuthenticationErrorSubscription() {
        viewModel.errorObservable.subscribe { [weak self] error in
            self?.loginErrorLabel.text = error
            self?.loginErrorLabel.isHidden = false
        } onError: { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
}
