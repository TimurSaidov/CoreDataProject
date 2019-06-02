//
//  NetworkService.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}

protocol RequestSenderProtocol {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
