//
//  reportCommentViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 5/30/23.
//

import Firebase
import FirebaseFirestore

class reportCommentViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    func reportComment(comment: Comment, reason: String) {
        
        // Upload the flagged comment and reason to Firestore
        
        let data = ["uid": comment.id!,
                    "text": comment.text,
                    "commentImageURL": comment.commentImageURl,
                    "commentLocation": comment.commentLocation,
                    "timestamp": Timestamp(date: Date()),
                    "reason": reason] as [String: Any]
        
        Firestore.firestore()
            .collection("flaggedComments")
            .document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload tweet with error .. \(error.localizedDescription)")
                    return
                }
                print("DEBUG: Did upload tweet..")
                
            }
    }
}
