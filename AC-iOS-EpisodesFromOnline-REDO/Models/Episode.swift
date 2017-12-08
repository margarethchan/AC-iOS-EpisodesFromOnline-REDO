//
//  Episode.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

/// http://api.tvmaze.com/shows/139/episodes

struct Episode: Codable {
    let name: String
    let season: Int?
    let number: Int?
    let image: ImageWrapper?
    let summary: String?
}


