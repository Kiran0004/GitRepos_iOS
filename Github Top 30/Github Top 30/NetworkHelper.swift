//
//  NetworkHelper.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 16/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import Foundation

public class NetworkHelper {
    
    private static var sharedHelper: NetworkHelper = {
        let networkHelper = NetworkHelper()
        return networkHelper
    }()

    class func shared() -> NetworkHelper {
        return sharedHelper
    }

    func fetchRepoDataWith(_ page: Int?, completionHandler: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        var urlString = "https://api.github.com/search/repositories?q=created:%3E2019-10-16&sort=stars&order=desc"
        if let pageNumber = page {
            urlString.append("&page=\(pageNumber)")
        }
        let url = URL(string: urlString)
        performGetRequest(url) { (responseData, responseCode, error) in
            guard let data = responseData else {
                completionHandler(nil, error)
                return
            }
            do {
                guard let todo = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        completionHandler(nil, error)
                        return
                }
                completionHandler(todo, error)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    func performGetRequest(_ targetURL: URL!, completion: @escaping (_ data: Data?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data, (response as! HTTPURLResponse).statusCode, error as NSError?)
            })
        }
        
        task.resume()
    }
}
