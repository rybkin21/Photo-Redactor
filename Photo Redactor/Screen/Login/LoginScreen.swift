//
//  LoginView.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 03.03.2025.
//

import SwiftUI

struct LoginScreen: View {

    @ObservedObject var model: ModelData

    var body: some View {

        ZStack {
            VStack {
                Spacer(minLength: 0)

                ZStack {
                    if UIScreen.main.bounds.height < 750 {
                        Image("logo")
                            .resizable()
                            .frame(width: 130, height: 130)
                    } else {
                        Image("logo")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.2))
                .cornerRadius(30)
                .padding(.top)

                VStack(spacing: 4) {

                    HStack(spacing: 10) {

                        Text("Photo")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundStyle(.white)

                        Text("Redactor")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundStyle(.cyan)
                    }

                    Text("lets choose your dream")
                        .foregroundStyle(.black.opacity(0.3))
                        .fontWeight(.heavy)
                }
                .padding(.top)

                VStack(spacing: 20) {

                    CustomTextField(image: "person", placeHolder: "Email", txt: $model.email)

                    CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password)
                }
                .padding(.top)

                Button(action: model.login) {

                    Text("LOGIN")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pink.opacity(0.8))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 22)

                Text("or")
                    .foregroundStyle(.black.opacity(0.3))
                    .fontWeight(.heavy)
                    .padding(.top, 8)

                GoogleSignInButton {
                    GoogleAuth.share.signInWithGoogle(presenting: getRootViewController()) { error in
                        print("ERROR: \(error.debugDescription)")
                    }
                }
                    .padding(.top, 8)

                HStack(spacing: 12) {

                    Text("Don't have an account?")
                        .foregroundStyle(Color.white.opacity(0.7))

                    Button(action: { model.isSignUp.toggle() }) {

                        Text("Sign Up Now")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.top, 15)

                Spacer(minLength: 0)

                Button(action: model.resetPassword) {

                    Text("Forget Password?")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                .padding(.vertical, 22)

            }

            if model.isLoading {
                LoadingView()
            }
        }
        .background(LinearGradient(colors: [Color.red.opacity(0.8), Color.pink.opacity(0.8)], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .fullScreenCover(isPresented: $model.isSignUp) {

            SignUpView(model: model)
        }
        // Alerts
        .alert(isPresented: $model.isLinkSend) {
            Alert(title: Text("Message"), message: Text("Password Reset Link Has Been Sent"), dismissButton: .destructive(Text("Ok")))
        }

        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
        })
    }

}

//#Preview {
//    LoginScreen(model: ModelData())
//}
