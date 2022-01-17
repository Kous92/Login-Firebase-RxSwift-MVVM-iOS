//
//  UserViewController.swift
//  Test login iOS Firebase RxSwift
//
//  Created by Koussaïla Ben Mamar on 30/12/2021.
//

import UIKit
import FirebaseAuth

class UserViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("Erreur à la déconnexion.")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
