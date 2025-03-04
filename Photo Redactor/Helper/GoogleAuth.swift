//
//  GoogleAuth.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 04.03.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

struct GoogleAuth {

    static let share = GoogleAuth()

    private init() { }

    func signInWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
          guard error == nil else {
              completion(error)
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result,  error in

                guard error == nil else {
                    // TODO: - Manage errors
                    return
                }
                print("Sign in")
                UserDefaults.standard.set(true, forKey: "log_Status")
            }
        }
    }
}
