//
//  RequestSender.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

class RequestSender: RequestSenderProtocol {
    
    
    // MARK: Public
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("URL string can't be parsed to URL."))
            return
        }
        
        let session = sessionConfiguration()
        
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            
            guard
                let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data)
                else {
                    completionHandler(Result.error("Recieved data can't be parsed."))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
    
    
    // MARK: Private
    
    private func sessionConfiguration() -> URLSession {
        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlConfiguration.urlCache = nil
        
        return URLSession.init(configuration: urlConfiguration)
    }
}
