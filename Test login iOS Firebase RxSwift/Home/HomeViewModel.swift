//
//  HomeViewModel.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 05/01/2022.
//

import Foundation
import RxSwift
import FirebaseAuth

final class HomeViewModel {
    // Est-ce que l'utilisateur s'est déjà connecté auparavant, si c'est le cas, Firebase Authentication le signalera et la session sera alors récupérée.
    func checkUserSession() -> Single<String> {
        return Single<String>.create { single in
            if let user = FirebaseAuth.Auth.auth().currentUser {
                print("Utilisateur connecté: \(user.uid)")
                single(.success(user.uid))
            } else {
                let error: FirebaseAuthError = .noSession
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
