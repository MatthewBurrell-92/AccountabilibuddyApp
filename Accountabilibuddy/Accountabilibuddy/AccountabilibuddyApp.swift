//
//  AccountabilibuddyApp.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 1/31/26.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AccountabilibuddyApp: App {
   @StateObject var viewModel = GoalViewModel()
   @StateObject var settings = UserSettings()
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
   //   init() {
   //           FirebaseApp.configure()
   //       }
   
   var body: some Scene {
      WindowGroup {
         if settings.username.isEmpty {
            UsernameSetupView()
               .environmentObject(settings)
               .environmentObject(viewModel)
         } else {
            ContentView()
               .environmentObject(settings)
               .environmentObject(viewModel)
         }
      }
   }
}
