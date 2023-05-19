//
//  editProfileViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 5/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class editProfileViewModel: ObservableObject {
    @Published  var fullname: String
    @Published  var username: String
    @Published  var email: String
    @Published  var college: String
    @Published  var profileImgURL: String
    private var user1: User
    
    private let db = Firestore.firestore()
    
    init(user: User) {
        self.user1 = user
        fullname = user.fullname
        username = user.username
        email = user.email
        college = user.college
        profileImgURL = user.profileImageUrl
    }
    
        
        func updateUserInfo() {
            guard let user = Auth.auth().currentUser else {
                // User is not authenticated
                return
            }
            
            
            
            db.collection("users").document(user.uid).updateData([
                "fullname": fullname,
                "username": username,
                "profileImageUrl": profileImgURL,
                "keywordsForLookup": user1.keywordsForLookup
            ]) { error in
                if let error = error {
                    print("Error updating user info: \(error.localizedDescription)")
                } else {
                    print("User info updated successfully")
                }
            }
        }
    

    
}
