//
//  newCommentViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 3/14/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class newCommentViewModel: ObservableObject{
    @Published var success = false
    let backend = commentService()
    @Published var commentImageURLString = ""
    
    func uploadComment(caption: String, commentLocation: String, commentImageURL: UIImage?) {
        if commentImageURL != nil {
                 imageUploader.uploadImage(use: "comment", image: commentImageURL!) { URL in
                    print("entered2")
                    self.commentImageURLString = URL
                     self.backend.uploadComment(text: caption, commentImageURL: self.commentImageURLString, commentLocation: commentLocation) { flip in
                         if flip {
                             self.success = true
                         }
                         else {
                             
                         }
                 }
            }
            }
        
    }
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 3_000_000_000)
            print("Done")
        }
        catch { }
    }
    
}
