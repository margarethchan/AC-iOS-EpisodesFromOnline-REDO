//
//  NetworkHelper.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class NetworkHelper {
    private init() {}
    static let manager = NetworkHelper()
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    func performDataTask(with url: URL, completionHandler: @escaping ((Data) -> Void), errorHandler: @escaping ((AppError) -> Void)) {
        self.urlSession.dataTask(with: url){(data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let data = data else {
                    errorHandler(AppError.noDataReceived)
                    return
                }
                guard (response as? HTTPURLResponse) != nil else {
                    errorHandler(AppError.badStatusCode)
                    return
                }
                
                if let error = error {
                    let error = error as NSError
                    if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                        errorHandler(AppError.noInternetConnection)
                        return
                    } else {
                        errorHandler(AppError.other(rawError: error))
                        return
                    }
                }
                completionHandler(data)
            }
            } .resume()
    }
}
