//
//  friendCommentsViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 4/8/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class friendCommentsViewModel: ObservableObject {
    @Published var arrrayComments: [Comment] = []
    @Published var userFriends = true
    
    init() {
        Task{
            userFriends = await hasFriends()
        }
        importCommentsFromFollowedUsers()
    }
    
    func hasFriends() async -> Bool {
        let db = Firestore.firestore()
        
        // Define the document path for the user whose followed users' comments you want to import
        let userDoc = db.collection("users").document(Auth.auth().currentUser!.uid) // Replace "users" with the collection name for your users in Firestore
        
        // Get the followed users' IDs from the user document
        try await userDoc.getDocument { document, error in
            guard let document = document, document.exists else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let data = document.data()
            let followedUserIDs = data?["friends"] as? [String] ?? []
            print(followedUserIDs)
            
            if followedUserIDs == []{
                self.userFriends = false
            }
            else {
                self.userFriends = true
            }
        }
        return userFriends
    }
    
    func importCommentsFromFollowedUsers()  {
        arrrayComments.removeAll()
            let db = Firestore.firestore()
            
            // Define the document path for the user whose followed users' comments you want to import
        let userDoc = db.collection("users").document(Auth.auth().currentUser!.uid) // Replace "users" with the collection name for your users in Firestore
            
            // Get the followed users' IDs from the user document
            userDoc.getDocument { document, error in
                guard let document = document, document.exists else {
                    print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let data = document.data()
                let followedUserIDs = data?["friends"] as? [String] ?? []
                print(followedUserIDs.isEmpty)
                // Query for comments from followed users
                if followedUserIDs.isEmpty == false {
                    print("1")
                    let commentsCollection = db.collection("comments")
                    commentsCollection
                        .whereField("uid", in: followedUserIDs) // Replace "authorID" with the field name for the author ID in your Firestore documents
                        .order(by: "timestamp", descending: true) // Sort comments by timestamp in descending order
                        .addSnapshotListener { querySnapshot, error in
                            if let snapshotDocuments = querySnapshot?.documents {
                                for doc in snapshotDocuments {
                                    let data = doc.data()
                                    if let uid = data["uid"] as? String,
                                       let timestamp = data["timestamp"] as? Timestamp,
                                        let text = data["text"] as? String,
                                        let commentLocation = data["commentLocation"] as? String,
                                       let commentImageURL = data["commentImageURL"] as? String {
                                        let newComment = Comment(id: doc.documentID, uid: uid, text: text, commentImageURl: commentImageURL, commentLocation: commentLocation, timestamp: timestamp)
                                        self.arrrayComments.append(newComment)
                                        
                                        //completion(comments)
                                    }
                                    }
                                }
                            }}
            }
        }
}
