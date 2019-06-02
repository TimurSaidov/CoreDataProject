//
//  NetworkManager.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    
    // MARK: Public Properties
    
    static let shared = NetworkManager()
    
    
    // MARK: Private Properties
    
    private let urlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let requestSender = RequestSender()
    
    
    // MARK: Public
    
    func downloadCourses(completion: @escaping () -> (), errorCompletion: @escaping () -> ()) {
        let coreDataManager = CoreDataManager.shared
        
        let requestConfig = RequestConfigFactory.CourseRequestConfig.courseRequestConfig()
        requestSender.send(config: requestConfig) { result in
            switch result {
            case .success(let array):
                let jsonCourses = array
                
                jsonCourses.forEach({ jsonCourse in
                    let course = Course(context: coreDataManager.privateContextToLoadCourses)
                    course.name = jsonCourse.name
                })
                
                do {
                    try coreDataManager.privateContextToLoadCourses.save()
                    try coreDataManager.mainContext.save()
                    try coreDataManager.privateContextToSaveCourses.save()
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Can't save context: \(error.localizedDescription)")
                }
            case .error(let error):
                print(error)
                
                DispatchQueue.main.async {
                    errorCompletion()
                }
            }
        }
        
//        guard let url = URL(string: urlString) else { return }
//
//        coreDataManager.privateContextToLoadCourses.perform {
//            do {
//                let data = try Data(contentsOf: url)
//
//                do {
//                    let jsonCourses = try JSONDecoder().decode([JSONCourse].self, from: data)
//
//                    jsonCourses.forEach({ jsonCourse in
//                        let course = Course(context: coreDataManager.privateContextToLoadCourses)
//                        course.name = jsonCourse.name
//                    })
//
//                    do {
//                        try coreDataManager.privateContextToLoadCourses.save()
//                        try coreDataManager.mainContext.save()
//                        try coreDataManager.privateContextToSaveCourses.save()
//
//                        DispatchQueue.main.async {
//                            completion()
//                        }
//                    } catch {
//                        print("Can't save context: \(error.localizedDescription)")
//                    }
//                } catch {
//                    print("Can't parse data: \(error.localizedDescription)")
//                }
//            } catch {
//                print("Can't fetch data from URL: \(error.localizedDescription)")
//            }
//        }
    }
}
