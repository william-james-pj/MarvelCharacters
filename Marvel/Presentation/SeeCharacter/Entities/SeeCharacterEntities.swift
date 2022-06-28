//
//  SeeCharacterEntities.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 27/06/22.
//

import Foundation

struct ContentAPIResult: Codable {
    let data: ContentDataContainer
}

struct ContentDataContainer: Codable {
    let results: [ContentModel]
}

struct ContentModel: Codable {
    let id: Int
    let title: String
    let thumbnail: [String: String]
}

struct AllContentModel {
    let title: String
    let content: [ContentModel]
}
