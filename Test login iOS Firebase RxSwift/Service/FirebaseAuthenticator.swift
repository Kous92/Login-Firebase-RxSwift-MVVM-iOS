//
//  FirebaseAuthenticator.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 28/12/2021.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthenticator {
    func authenticateUser(with email: String, and password: String, completion: @escaping (Result<String, FirebaseAuthError>) -> ()) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                if let error = error, let code = AuthErrorCode(rawValue: error._code) {
                    completion(.failure(self?.handleAuthError(with: code) ?? .unknown))
                    return
                }
                
                completion(.failure(.unknown))
                return
            }
            
            completion(.success(result?.user.uid ?? ""))
        }
    }
    
    func registerUser(with email: String, and password: String, completion: @escaping (Result<String, FirebaseAuthError>) -> ()) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                print(error.debugDescription)
                if let error = error, let code = AuthErrorCode(rawValue: error._code) {
                    completion(.failure(self?.handleAuthError(with: code) ?? .unknown))
                    return
                }
                
                completion(.failure(.unknown))
                return
            }
            
            completion(.success("Votre compte a été créé avec succès."))
        }
    }
    
    func handleAuthError(with errorCode: AuthErrorCode) -> FirebaseAuthError {
        switch errorCode {
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return .invalidEmail
        case .networkError:
            return .networkError
        case .userDisabled:
            return .userDisabled
        case .userNotFound:
            return .userNotFound
        case .weakPassword:
            return .weakPassword
        case .wrongPassword:
            return .wrongPassword
        default:
            return .unknown
        }
    }
}
