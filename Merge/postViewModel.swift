//
//  postViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 4/10/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


class postViewModel: ObservableObject {
    var place1: Place
    
    init(place1: Place) {
        self.place1 = place1
        
        //self.place1.didLike = checkDocument()
    }
    
    func like(city: String) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            db.collection("Activities").document("Bars").collection(city).document(place1.name).updateData(["Likes": FieldValue.increment(Int64(1))]) { _ in
                db.collection("users").document(uid).collection("likedPlaces").document(self.place1.name).setData([:]) { _ in
                    DispatchQueue.main.async {
                        self.place1.didLike = true // Update the didLike property
                        self.place1.likes += 1
                    }
                }
            }
        }
    func unlike() {
        
    }
    
    func checkDocument() -> Bool  {
            let semaphore = DispatchSemaphore(value: 1)
            var documentFound = false
            
            let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(Auth.auth().currentUser!.uid)// Replace with your actual collection name
        let documentRef = collectionRef.collection("likedPlaces").document(place1.name) // Replace with your actual document ID
            
            documentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Document found
                    documentFound = true
                } else {
                    // Document not found
                    documentFound = false
                }
                semaphore.signal()
            }
            
            semaphore.wait()
            print("\(documentFound) skfjjffjfj")
            return documentFound
        }
}
