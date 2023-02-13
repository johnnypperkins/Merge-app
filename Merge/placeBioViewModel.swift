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
 
     init(place: Place) {
         self.locationComments.removeAll()
         getComments(place: place)
 }
 
     func getComments(place: Place) {
         backend.getComments(location: place.name) { comments in
            self.locationComments.removeAll()
            self.locationComments = comments
             print(comments)
        }
     }
 }
 
