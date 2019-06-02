//
//  RequestConfig.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

// Конфиг.
struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

// Результат.
enum Result<T> {
    case success(T)
    case error(String)
}

// Парсер. Может быть фабрика по производству парсеров.
class CourseParser: ParserProtocol {
    
    typealias Model = [JSONCourse]
    
    
    // MARK: Public
    
    func parse(data: Data) -> [JSONCourse]? {
        var courses: [JSONCourse] = []
        
        do {
            courses = try JSONDecoder().decode([JSONCourse].self, from: data)
        } catch {
            print("Error serializing JSON \(error)")
        }
        
        return courses
    }
}
