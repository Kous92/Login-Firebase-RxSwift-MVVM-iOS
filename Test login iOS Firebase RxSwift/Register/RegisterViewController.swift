//
//  RegisterViewController.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 28/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerStatusLabel: UILabel!
    @IBOutlet weak var registerButton: CustomButton!
    
    let disposeBag = DisposeBag()
    let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerStatusLabel.isHidden = true
        setBindings()
        setRegisterButtonSubscription()
        setRegistrationSubscription()
        setRegistrationErrorSubscription()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    private func setConfirmPasswordFieldColor(valid: Bool) {
        confirmPasswordField.layer.borderWidth = valid ? 1 : 0
        confirmPasswordField.layer.cornerRadius = 8
        confirmPasswordField.layer.borderColor = valid ? #colorLiteral(red: 0.01251956106, green: 1, blue: 0, alpha: 1) : .none
    }
}

extension RegisterViewController {
    private func setBindings() {
        emailField.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordField.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        confirmPasswordField.rx.text.map { $0 ?? "" }.bind(to: viewModel.confirmPasswordSubject).disposed(by: disposeBag)
        viewModel.isValid().bind(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: registerButton.rx.alpha).disposed(by: disposeBag)
        
        viewModel.isEmailValid().subscribe { [weak self] valid in
            self?.setEmailFieldColor(valid: valid)
        }.disposed(by: disposeBag)
        
        viewModel.isPasswordValid().subscribe { [weak self] valid in
            self?.setPasswordFieldColor(valid: valid)
        }.disposed(by: disposeBag)
        
        viewModel.isConfirmPasswordValid().subscribe { [weak self] valid in
            self?.setConfirmPasswordFieldColor(valid: valid)
        }.disposed(by: disposeBag)
    }
    
    private func setRegisterButtonSubscription() {
        registerButton.rx.tap
            .withLatestFrom(viewModel.isValid())
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let email = self?.emailField.text, let password = self?.passwordField.text else {
                    fatalError("Erreur email et mot de passe")
                }
                self?.viewModel.register(with: email, and: password)
            }.disposed(by: disposeBag)
    }
    
    private func setRegistrationSubscription() {
        viewModel.registerObservable.subscribe { [weak self] message in
            self?.registerStatusLabel.text = message
            self?.registerStatusLabel.isHidden = false
        } onError: { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    private func setRegistrationErrorSubscription() {
        viewModel.errorObservable.subscribe { [weak self] error in
            self?.registerStatusLabel.text = error
            self?.registerStatusLabel.isHidden = false
        } onError: { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
}
