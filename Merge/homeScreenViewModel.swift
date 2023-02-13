//
//  homeScreenViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 3/21/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

class homeScreenViewModel: ObservableObject {
    @Published var success = false
    let backend = commentService()
    @Published var places = [Place]()
    @Published var city: String
    
    init(city1: String) {
        self.city = city1
        loadPlaces(location: city1)
    }
    
    func loadPlaces (location: String) {
        places.removeAll()
        self.city = location
        let db = Firestore.firestore()
        db.collection("Activities").document("Bars").collection(location).order(by: "Likes", descending: true)
            .addSnapshotListener { [self] (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                    
                } else {
                    self.places.removeAll()
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let address = data["Address"] as? String,
                               let name = data["Name"] as? String,
                               let likes = data["Likes"] as? Int,
                               let crowd = data["Crowd"] as? Int {
                                var newPlace = Place(name: name, likes: likes, crowd: crowd, address: address)
                                Task {await checkDocument(newPlace: newPlace) { success in
                                    print("\(success) s s ss s s")
                                    newPlace.didLike = success
                                }
                                }
                                self.places.append(newPlace)
                                print(self.places)
                            }
                        }
                    }
                }
            }
    }
    func checkDocument(newPlace: Place, completion: @escaping (Bool) -> Void) async {
            let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(Auth.auth().currentUser!.uid)// Replace with your actual collection name
        let documentRef = collectionRef.collection("likedPlaces").document(newPlace.name) // Replace with your actual document ID
            
          await documentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Document found
                    completion(true)
                } else {
                    // Document not found
                    completion(false)
                }
            }
        }
}
