//
//  PageResult.swift
//  Pokidex
//
//  Created by Consultant on 5/4/22.
//

import Foundation

struct PageResult: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [BasicData]
}

struct BasicData: Decodable {
    var name: String
    var url: String
}
