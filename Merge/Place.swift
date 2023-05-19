//
//  Place.swift
//  Merge
//
//  Created by Johnny Perkins on 2/16/23.
//

import Foundation

struct Place: Identifiable, Decodable {
    var id = UUID()
    var name: String
    var likes: Int
    var crowd: Int
    var address: String
    var imageURL: String
    var city: String
    
    var didLike: Bool? = false
}
