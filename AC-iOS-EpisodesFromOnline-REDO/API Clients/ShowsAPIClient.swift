//
//  ShowsAPIClient.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct ShowAPIClient {
    private init() {}
    static let manager = ShowAPIClient()
    
    func getShows(from urlStr: String,
                  completionHandler: @escaping ([ShowInfo]) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else { // makes a URL out of a URL string
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let showInfo = try JSONDecoder().decode([ShowInfo].self, from: data)
                completionHandler(showInfo)
            }
            catch {
                print(error)
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
