//
//  worldViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 3/21/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class worldViewModel: ObservableObject {
    @Published var queriedCities: [String] = []
    private let db = Firestore.firestore()
    var city = "San Francisco"

    init() {
        setCity(location: city)
        fetchCities()
    }

    func setCity(location: String) {
        self.city = location
    }
    
    func fetchCities() {
        db.collection("Activities").document("Bars")
        .getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                let group_array = data?["Cities"] as? [String] ?? [""]
                print(group_array)
                self.queriedCities = group_array
                
        }
        }
    }
}
