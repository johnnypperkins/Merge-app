//
//  objectLookupViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 2/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class objectLookupViewModel: ObservableObject {
    var places1: [Place] = []
    
    private let db = Firestore.firestore()
    
    func loadPlaces1 () -> [Place] {
        db.collection("Activities").document("Bars").collection("San Francisco").order(by: "Likes", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                    
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let address = data["Address"] as? String,
                               let name = data["Name"] as? String,
                                let likes = data["Likes"] as? Int,
                                let crowd = data["Crowd"] as? Int,
                                let imageURL = data["ImageURL"] as? String,
                                let city = data["City"] as? String {
                                let newPlace = Place(name: name, likes: likes, crowd: crowd, address: address, imageURL: imageURL, city: city)
                                self.places1.append(newPlace)
                                print(self.places1)
                            }
                        }
                    }
                }
            }
        return places1
    }
    
   
}
