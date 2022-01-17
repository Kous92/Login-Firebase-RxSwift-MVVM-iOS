//
//  LoginViewModel.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 28/12/2021.
//

import Foundation
import RxSwift

final class LoginViewModel {
    private let firebaseAuthenticator = FirebaseAuthenticator()
    
    let emailSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    private var loginSubject = PublishSubject<String>()
    private var errorSubject = PublishSubject<String>()
    
    var loginObservable: Observable<String> {
        return loginSubject
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
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(emailSubject.asObservable(), passwordSubject.asObservable())
            .map { username, password in
                return username.isEmailValid() && password.isPasswordValid()
            }.startWith(false)
    }
    
    func authenticate(with email: String, and password: String) {
        firebaseAuthenticator.authenticateUser(with: email, and: password) { [weak self] result in
            switch result {
            case .success(let uid):
                self?.loginSubject.onNext(uid)
            case .failure(let error):
                self?.errorSubject.onNext(error.rawValue)
            }
        }
    }
}
