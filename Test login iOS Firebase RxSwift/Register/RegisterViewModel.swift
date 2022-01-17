//
//  RegisterViewModel.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 30/12/2021.
//

import Foundation
import RxSwift

final class RegisterViewModel {
    private let firebaseAuthenticator = FirebaseAuthenticator()
    
    let emailSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    let confirmPasswordSubject = PublishSubject<String>()
    
    private var registerSubject = PublishSubject<String>()
    private var errorSubject = PublishSubject<String>()
    
    var registerObservable: Observable<String> {
        return registerSubject
    }
    
    var errorObservable: Observable<String> {
        return errorSubject
    }
    
    func isEmailValid() -> Observable<Bool> {
        return emailSubject.asObservable().map { $0.isEmailValid() }.startWith(false)
    }
    
    func isPasswordValid() -> Observable<Bool> {
        return passwordSubject.asObservable().map { $0.isPasswordValid() }.startWith(false)
    }
    
    func isConfirmPasswordValid() -> Observable<Bool> {
        Observable.combineLatest(passwordSubject.asObservable(), confirmPasswordSubject.asObservable())
            .map { password, confirmPassword in
                return password == confirmPassword
            }.startWith(false)
    }
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(emailSubject.asObservable(), passwordSubject.asObservable(), confirmPasswordSubject.asObservable()).map { email, password, confirmPassword in
            return email.isEmailValid() && password.isPasswordValid() && password == confirmPassword
        }.startWith(false)
    }
    
    func register(with email: String, and password: String) {
        firebaseAuthenticator.registerUser(with: email, and: password) { [weak self] result in
            switch result {
            case .success(let message):
                self?.registerSubject.onNext(message)
            case .failure(let error):
                self?.errorSubject.onNext(error.rawValue)
            }
        }
    }
}
