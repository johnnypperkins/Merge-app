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
    
    let user: User
    
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
        service.fetchComments(forUid: uid) { comments in
            self.comments = comments
            
            /*for index in 0 ..< comments.count {
                self.comments[index].uid = self.uid
            }*/
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

