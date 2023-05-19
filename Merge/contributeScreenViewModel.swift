//
//  contributeScreenViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 5/12/23.
//

import Firebase

class contributeScreenViewModel: ObservableObject {
    private let database = Firestore.firestore()
    @Published var barImageURLString = ""
    @Published var success = false
    @Published var queriedCities: [String] = []
    @Published var errorMessage = ""
    init() {
        fetchCities()
    }
    
    /*func addBarSuggestion(barName: String, city: String, image: UIImage?) {
        var data: [String: Any] = [            "Name": barName,            "City": city        ]
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            data["ImageURL"] = imageData
        }
        
        database.collection("barSuggestions").addDocument(data: data) { error in
            if let error = error {
                print("Error adding bar suggestion: \(error.localizedDescription)")
            } else {
                print("Bar suggestion added successfully")
                // Display confirmation message
            }
        }
    }*/
    
    func uploadNewBar(name: String, city: String, barImageURL: UIImage?) {
        if barImageURL != nil {
                 imageUploader.uploadImage(use: "newPlace", image: barImageURL!) { URL in
                    print("entered2")
                    self.barImageURLString = URL
                     self.uploadBar(name: name, barImageURLS: self.barImageURLString, city: city) { flip in
                         if flip {
                             self.success = true
                         }
                         else {
                             
                         }
                 }
            }
            }
        
    }
    
    func uploadBar(name: String, barImageURLS: String, city: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["Name": name, "City": city, "ImageURL": barImageURLS]
        
        Firestore.firestore()
            .collection("additionalBars")
            .document()
            .setData(data) { error in
                if let error = error {
                    
                    print("DEBUG: Failed to upload tweet with error .. \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                print("DEBUG: Did upload tweet..")
                
                completion(true)
            }
    }
    
    func fetchCities() {
        let db = Firestore.firestore()
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
