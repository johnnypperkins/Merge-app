//
//  likesBackend.swift
//  Merge
//
//  Created by Johnny Perkins on 2/13/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

struct likesBackend {
    
  /*  func printLikes() {
        let db = Firestore.firestore()
        print(db.collection("Activities").document("Bars").collection("SanFrancisco").document("Jaxson"))
        
    }
   */
    
    
    
}
func addLike (category: String, city: String, name: String) {
    let db = Firestore.firestore()
    var tmp = 0
    let docRef = db.collection("Activities").document(category).collection(city).document(name)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
        } else {
            print("Document does not exist")
        }
            tmp = Int(document?.get("Likes") as! Int)
            tmp = tmp + 1
            docRef.updateData([
                "Likes": tmp
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print(document?.data().map(String.init(describing: )) ?? "nil")
                    print("Document successfully updated")
            }
        }
    }
}

func subtractLike (category: String, city: String, name: String) {
    let db = Firestore.firestore()
    var tmp = 0
    let docRef = db.collection("Activities").document(category).collection(city).document(name)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
        } else {
            print("Document does not exist")
        }
            tmp = Int(document?.get("Likes") as! Int)
            tmp = tmp - 1
            docRef.updateData([
                "Likes": tmp
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print(document?.data().map(String.init(describing: )) ?? "nil")
                    print("Document successfully updated")
            }
        }
    }
}


func getLikes(category: String, city: String, name: String) {
    let db = Firestore.firestore()
    let docRef = db.collection("Activities").document(category).collection(city).document(name)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            
        } else {
            print("Document does not exist")
        }
    }
    
}

import Firebase

struct commentService {
    
    func uploadComment(text: String, commentImageURL: String, commentLocation: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "text": text,
                    "commentImageURL": commentImageURL,
                    "commentLocation": commentLocation,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        Firestore.firestore()
            .collection("comments")
            .document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload tweet with error .. \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("DEBUG: Did upload tweet..")
                
                completion(true)
            }
    }
    
    func getComments(location: String, completion: @escaping([Comment]) -> Void) {
        var comments: [Comment] = []
        comments.removeAll()
        Firestore.firestore().collection("comments")
            .whereField("commentLocation", isEqualTo: location)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                    
                } else {
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
                                print(comments)
                                completion(comments)
                            }
                        }
                    }
                }
            }
    }

    
    func fetchComments(forUid uid: String, completion: @escaping([Comment]) -> Void) {
        var comments: [Comment] = []
        Firestore.firestore().collection("comments")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (snapshot, error) in
                        if let e = error {
                            print("There was an issue retrieving data from Firestore. \(e)")
                            
                        } else {
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
                                        print(comments)
                                        completion(comments)
                                    }
                                }
                            }
                        }
                
        }
        
    }
}
