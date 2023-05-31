//
//  MergeApp.swift
//  Merge
//
//  Created by Johnny Perkins on 2/13/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


@main
struct MergeApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    init() {
        FirebaseApp.configure()
        Auth.auth()
        Firestore.firestore()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
              //  if authViewModel.userSession != nil {
                   // ContentView()
                     //   .environmentObject(authViewModel)
               // } else {
                  //  worldView()
                      //  .environmentObject(authViewModel)
                    // }
                    AuthenticatedView {
                         ContentView()
                            .environmentObject(authViewModel)
                     }
              //  }
            }
            
        }
    }
}
