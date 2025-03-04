//
//  ModelData.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 03.03.2025.
//

import SwiftUI
import Firebase

class ModelData: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    @Published var isLinkSend = false

    // AlertView With TextFields

    // Erorr Alerts

    @Published var alert = false
    @Published var alertMsg = ""

    // User status

    @AppStorage("log_Status") var status = false

    // Loading

    @Published var isLoading = false

    func resetPassword() {

        let alert = UIAlertController(title: "Reset Password", message: "Enter Your E-Mail ID To Reset Your Password", preferredStyle: .alert)

        alert.addTextField { (password) in
            password.placeholder = "Email"
        }

        let proceed = UIAlertAction(title: "Reset", style: .default) { _ in

            // sending password link

            if alert.textFields![0].text! != "" {

                withAnimation {
                    self.isLoading.toggle()
                }

                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { error in

                    withAnimation {
                        self.isLoading.toggle()
                    }

                    if error != nil {
                        self.alertMsg = error!.localizedDescription
                        self.alert.toggle()
                        return
                    }

                    // Alerting user

                    self.alertMsg = "Password Reset Link Has Been Sent !!!"
                    self.alert.toggle()
                }
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancel)
        alert.addAction(proceed)

        // Presenting

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }

    // Login

    func login() {

        // cheking all fields are inputted correctly

        if email == "" || password == "" {
            self.alertMsg = "Fill the contents properly!!!"
            self.alert.toggle()
            return
        }

        withAnimation {
            self.isLoading.toggle()
        }

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

            withAnimation {
                self.isLoading.toggle()
            }

            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }

            // cheking if user is verifed or not

            let user = Auth.auth().currentUser

            if !user!.isEmailVerified {
                self.alertMsg = "Please Verify Email Adress!!!"
                self.alert.toggle()
                // logging out
                try! Auth.auth().signOut()

                return
            }

            // setting user status as true

            withAnimation {
                self.status = true
            }
        }
    }

    // SignUp

    func signUp() {

        // cheking

        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == "" {
            self.alertMsg = "Fill contents properly!!!"
            self.alert.toggle()
            return
        }

        if password_SignUp != reEnterPassword {

            self.alertMsg = "Password Mismatch!!!"
            self.alert.toggle()
            return
        }

        withAnimation {
            self.isLoading.toggle()
        }

        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (result, error) in

            withAnimation {
                self.isLoading.toggle()
            }

            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }

            // sending Verification Link

            result?.user.sendEmailVerification(completion: { (error) in
                if error != nil {
                    self.alertMsg = error!.localizedDescription
                    self.alert.toggle()
                    return
                }

                // Alerting User To Verify email

                self.alertMsg = "Email Verification Has Been Sent !!! Verify Your Email ID !!!"
                self.alert.toggle()
            })
        }
    }

    // Log Out

    func logOut() {

        try! Auth.auth().signOut()

        withAnimation {
            self.status = false
        }

        // clearing all data

        email = ""
        password = ""
        email_SignUp = ""
        password_SignUp = ""
        reEnterPassword = ""
    }
}
