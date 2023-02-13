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
    init() {
        FirebaseApp.configure()
        Auth.auth()
        Firestore.firestore()
      }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                AuthenticatedView {
                    ContentView()
                }
            }
        }

    }
}
