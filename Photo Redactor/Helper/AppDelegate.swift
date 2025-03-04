//
//  AppDelegate.swift
//  Photo Redactor
//
//  Created by Ivan Rybkin on 04.03.2025.
//

// Connecting Firebase
import SwiftUI
import Firebase
import GoogleSignIn

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
