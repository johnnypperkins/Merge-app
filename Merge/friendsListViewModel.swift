//
//  friendsListViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 4/14/23.
//
import SwiftUI
import Foundation
import Firebase
import Foundation

class friendsListViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var userFriends: [User] = []
    
    init(user: User) {
        importCommentsFromFollowedUsers(user1:user)
    }
    
    func importCommentsFromFollowedUsers(user1: User)  {
        friends.removeAll()
        let db = Firestore.firestore()
        
        // Define the document path for the user whose followed users' comments you want to import
        let userDoc = db.collection("users").document(user1.id!) // Replace "users" with the collection name for your users in Firestore
        
        // Get the followed users' IDs from the user document
        userDoc.getDocument { document, error in
            guard let document = document, document.exists else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let data = document.data()
            self.friends = data?["friends"] as? [String] ?? []
            if self.friends.isEmpty == false{
                db.collection("users").whereField("UID", in: self.friends).getDocuments { querySnapshot, error in
                    guard let documents = querySnapshot?.documents, error == nil else {return}
                    self.userFriends = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: User.self)
                    }
                    print(self.userFriends)
                    print("hello")
                }
            }
        }
    }
}
