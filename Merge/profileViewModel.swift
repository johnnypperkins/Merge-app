//
//  profileViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 3/13/23.
//
import SwiftUI
import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var comments = [Comment]()
    //@Published var likedTweets = [Comment]()
    private let service = commentService()
    private let uService = userService()
//    private let usersService = userService()
    @Published var isFollow: Bool = false
    @Published var followerCount: Int = 0
    
    @Published var user: User
    
    init(user: User) {
        //self.getCountOfStringsInArrayField(user1: user)
        self.user = user
        //self.isFollow = uService.isFollowed(id: user.id!)
        self.getUserComments()
        Task{
            await self.isFollowedd(id: user.id!)
            await self.getCountOfStringsInArrayField(user1: user)
        }
        //self.fetchLikedTweets()
    }
    
    
     var actionButtonTitle: String {
        if user.isCurrentUser == true {
            return "Edit"
        }
        
        else{
            if isFollow == true {
                return "Unmerge"
            }
            else {
                return "Merge"
            }
        }
    }
    
    /*func tweets(forFilter filter: TweetFilterViewModel) -> [Tweet] {
        switch filter {
            case .tweets:
                return tweets
            case .replies:
                return tweets
            case .likes:
                return likedTweets
        }
    }*/
    
    
    func isFollowedd (id: String) async  {
        var iss = true
        let db = Firestore.firestore()
        
        // Get a reference to the document to be read
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        Task{
            try await docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    guard let array = data?["friends"] as? [String]
                    else {docRef.setData(["friends": []], merge: true) { error in
                        if let error = error {
                            print("Error creating array field: \(error)")
                        } else {
                            print("Array field created successfully.")
                        }
                        
                    }
                        return
                    }
                    
                    
                    // Check if the string is in the array field
                    if array.contains(id) {
                        print("The string is in the array.")
                        self.isFollow = true
                    } else {
                        print("The string is not in the array.")
                        self.isFollow = false
                    }
                }
            }
            
        }
    }
    
    func follow () {
        uService.followBack(uid: Auth.auth().currentUser?.uid ?? "", id: user.id!)
        isFollow = true
        Task{
            await getCountOfStringsInArrayField(user1: user)
        }
    }
    
    func unfollow () {
        uService.unfollow(uid: Auth.auth().currentUser?.uid ?? "", id: user.id!)
        isFollow = false
        Task{
            await getCountOfStringsInArrayField(user1: user)
        }
    }
    
    func getUserComments() {
        guard let uid = user.id else { return }
        Firestore.firestore().collection("comments")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("There was an issue retrieving data from Firestore: \(error)")
                    return
                }
                
                var comments: [Comment] = []
                
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data["uid"] as? String,
                           let timestamp = data["timestamp"] as? Timestamp,
                           let text = data["text"] as? String,
                           let commentLocation = data["commentLocation"] as? String,
                           let commentImageURL = data["commentImageURL"] as? String {
                            let newComment = Comment(id: doc.documentID, uid: uid, text: text, commentImageURl: commentImageURL, commentLocation: commentLocation, timestamp: timestamp)
                            comments.append(newComment)
                        }
                    }
                }
                
                self.comments = comments
                print(comments)
            }
    }

    func fetchComments(forUid uid: String, completion: @escaping ([Comment]) -> Void) {
        Firestore.firestore().collection("comments")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("There was an issue retrieving data from Firestore: \(error)")
                    return
                }
                
                var comments: [Comment] = []
                
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data["uid"] as? String,
                           let timestamp = data["timestamp"] as? Timestamp,
                           let text = data["text"] as? String,
                           let commentLocation = data["commentLocation"] as? String,
                           let commentImageURL = data["commentImageURL"] as? String {
                            let newComment = Comment(id: doc.documentID, uid: uid, text: text, commentImageURl: commentImageURL, commentLocation: commentLocation, timestamp: timestamp)
                            comments.append(newComment)
                        }
                    }
                }
                
                completion(comments)
            }
    }




    
    func getCountOfStringsInArrayField(user1: User) async{
        var count = 0
        // Assuming you have a reference to your Firebase Firestore database
        let db = Firestore.firestore()

        // Replace "yourCollection" with the name of your collection
        // and "yourDocumentID" with the ID of the document you want to fetch
        let docRef = db.collection("users").document(user1.id!)

        // Fetch the document
        Task{
            await docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let array = document.get("friends") as? [String] {
                        // Access the array field and get the count
                        self.followerCount = array.count
                        print("Count of strings in array: \(count)")
                    } else {
                        print("Array field not found or not of type [String]")
                    }
                } else {
                    print("Document does not exist")
                }
            }
                
            }
        }
    
        private let db = Firestore.firestore()
        private var counterListener: ListenerRegistration?
        private var listener: ListenerRegistration?
        
        func startListening() {
            let counterRef = db.collection("users").document(user.id!)
            counterListener = counterRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard document.data() != nil else {
                    print("Document data was empty.")
                    return
                }
                guard let userUpdated = try? documentSnapshot!.data(as: User.self) else { return }
                    self.user = userUpdated
                
            }
        }
        
        func stopListening() {
            counterListener?.remove()
            listener?.remove()
        }
    }
  /*  func fetchLikedTweets() {
        guard let uid = user.id else { return }
        
        service.fetchLikedTweets(forUid: uid) { tweets in
            self.likedTweets = tweets
            
            for index in 0 ..< tweets.count {
                let uid = tweets[index].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.likedTweets[index].user = user
                }
            }
        }
    } */

