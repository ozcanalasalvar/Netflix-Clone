//
//  YoutubeSearchResponse.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 13.11.2024.
//

import Foundation


struct YoutubeSearchResponse: Codable {
    let items:  [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
