//
//  placeBioViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 3/15/23.
//

 import Foundation
 import UIKit
 import FirebaseFirestore
 
 class placeBioViewModel: ObservableObject {
     @Published var success = false
     let backend = commentService()
     @Published var locationComments = [Comment]()
     @Published var ratingSliderValue: Float = 0
     @Published var bar: Place
     @Published var ratingAverageValue: Double = 0
     @Published var crowdAverageValue: Double = 0
     @Published var waitAverageValue: Double = 0
 
     init(place: Place) {
         self.bar = place
         self.locationComments.removeAll()
         getComments(place: place)
         calculateAverageValue(slider: "ratingSliderValues")
         calculateAverageValue(slider: "crowdSliderValues")
         calculateAverageValue(slider: "waitSliderValues")
         
 }
 
     func getComments(place: Place) {
         backend.getComments(location: place.name) { comments in
            self.locationComments.removeAll()
            self.locationComments = comments
             print(comments)
        }
     }
     
     func uploadSliderValue(value: Double, slider: String) {
         let db = Firestore.firestore().collection("Activities").document("Bars").collection(bar.city).document(bar.name)
             //let value = Double(sliderValue)
             
             let timestamp = Timestamp()
             
             // Assuming you have a collection called "sliderValues" in Firestore
             db.collection(slider).addDocument(data: [
                 "value": value,
                 "timestamp": timestamp
             ]) { error in
                 if let error = error {
                     print("Error uploading value: \(error.localizedDescription)")
                 } else {
                     print("Value uploaded successfully!")
                     self.calculateAverageValue(slider: slider)
                 }
             }
         }
     
     func calculateAverageValue(slider: String) {
             let db = Firestore.firestore().collection("Activities").document("Bars").collection(bar.city).document(bar.name)
             
             // Assuming you have a collection called "sliderValues" in Firestore
             db.collection(slider).getDocuments { snapshot, error in
                 if let error = error {
                     print("Error fetching documents: \(error.localizedDescription)")
                     return
                 }
                 
                 guard let documents = snapshot?.documents else {
                     print("No documents available")
                     return
                 }
                 
                 let values = documents.compactMap { $0.data()["value"] as? Double }
                 let sum = values.reduce(0, +)
                 
                 DispatchQueue.main.async {
                     if slider == "ratingSliderValues" {
                         self.ratingAverageValue = sum / Double(values.count)
                     }
                     else if slider == "crowdSliderValues" {
                         self.crowdAverageValue = sum / Double(values.count)
                     }
                     else if slider == "waitSliderValues" {
                         self.waitAverageValue = sum / Double(values.count)
                     }
                 }
             }
         }
     
     func deleteOldDocuments() {
         let db = Firestore.firestore()
         let subcollectionRef = db.collection("Activities").document("Bars").collection(bar.city).document(bar.name).collection("ratingSliderValues")
         
         let twoDayAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
         
         subcollectionRef
             .whereField("timestamp", isLessThan: twoDayAgo)
             .getDocuments { (querySnapshot, error) in
                 if let error = error {
                     print("Error fetching documents: \(error)")
                 } else {
                     for document in querySnapshot!.documents {
                         let documentRef = subcollectionRef.document(document.documentID)
                         documentRef.delete { error in
                             if let error = error {
                                 print("Error deleting document: \(error)")
                             } else {
                                 print("Document deleted successfully")
                             }
                         }
                     }
                 }
             }
     }
 }
 
