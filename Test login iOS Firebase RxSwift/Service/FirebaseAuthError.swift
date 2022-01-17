//
//  FirebaseAuthError.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 05/01/2022.
//

import Foundation

enum FirebaseAuthError: String, Error {
    case emailAlreadyInUse = "Erreur: un compte existe déjà."
    case invalidEmail = "L'adresse e-mail saisie est invalide."
    case networkError = "Problème de connexion Internet. Veuillez réessayer."
    case userDisabled = "Votre compte a été désactivé. Merci de contacter l'administrateur."
    case userNotFound = "Aucun compte n'existe."
    case weakPassword = "Votre mot de passe est trop faible."
    case wrongPassword = "L'email ou le mot de passe renseigné est incorrect."
    case noSession = "Aucune session."
    case unknown = "Une erreur est survenue."
}
