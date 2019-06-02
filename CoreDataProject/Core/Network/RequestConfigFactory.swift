//
//  RequestConfigFactory.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

class CourseURLRequest: RequestProtocol {
    
    
    // MARK: Public Properties
    
    var urlRequest: URLRequest? = URLRequest(url: makeURL())
    
    
    // MARK: Public
    
    static func makeURL() -> URL {
        let url = URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses")!
        return url
    }
}

struct RequestConfigFactory {
    struct CourseRequestConfig {
        static func courseRequestConfig() -> RequestConfig<CourseParser> {
            return RequestConfig<CourseParser>(request: CourseURLRequest(), parser: CourseParser())
        }
    }
}
