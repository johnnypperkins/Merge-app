//
//  Comment.swift
//  Merge
//
//  Created by Johnny Perkins on 3/14/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    var text: String
    var commentImageURl: String
    var commentLocation: String
    var timestamp: Timestamp
}
