//
//  SignUpView.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 03.03.2025.
//

import SwiftUI

struct SignUpView: View {

    @ObservedObject var model: ModelData

    var body: some View {

        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
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

                        Text("New")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundStyle(.white)

                        Text("Profile")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundStyle(.cyan)
                    }

                    Text("Create a profile for you")
                        .foregroundStyle(.black.opacity(0.3))
                        .fontWeight(.heavy)
                }
                .padding(.top)

                VStack(spacing: 20) {

                    CustomTextField(image: "person", placeHolder: "Email", txt: $model.email_SignUp)

                    CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password_SignUp)

                    CustomTextField(image: "lock", placeHolder: "Re-Enter", txt: $model.reEnterPassword)
                }
                .padding(.top)

                Button(action: model.signUp) {

                    Text("SIGNUP")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pink.opacity(0.8))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.vertical, 22)

                Spacer(minLength: 0)
            }

            Button(action: { model.isSignUp.toggle() }) {

                Image(systemName: "xmark")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top, 10)

            if model.isLoading {
                LoadingView()
            }
        })
        .background(LinearGradient(colors: [Color.red.opacity(0.8), Color.pink.opacity(0.8)], startPoint: .top, endPoint: .bottom).ignoresSafeArea())

        // Alerts
        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {

                // if email link sent means closing the singupView

                if model.alertMsg == "Email Verification Has Been Sent !!! Verify Your Email ID !!!" {

                    model.isSignUp.toggle()
                    model.email_SignUp = ""
                    model.password_SignUp = ""
                    model.reEnterPassword = ""
                }
            }))
        })
    }
}
