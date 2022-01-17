//
//  ViewController.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 18/12/2021.
//

import UIKit
import FirebaseAuth
import RxSwift

final class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBinding()
    }
    
    private func setBinding() {
        viewModel.checkUserSession()
            .subscribe { [weak self] event in
                switch event {
                case .success(let uid):
                    self?.goToUserView(with: uid)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
    private func goToUserView(with uid: String) {
        guard let userViewController = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {
            fatalError("Le ViewController n'est pas détecté dans le storyboard")
        }
        
        userViewController.uid = uid
        userViewController.modalPresentationStyle = .fullScreen
        self.present(userViewController, animated: true, completion: nil)
    }
    
    @IBAction func goToLoginButton(_ sender: Any) {
        guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            fatalError("Le ViewController n'est pas détecté dans le storyboard")
        }
        
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func goToRegisterButton(_ sender: Any) {
        guard let registerViewController = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
            fatalError("Le ViewController n'est pas détecté dans le storyboard")
        }
        
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: true, completion: nil)
    }
}

