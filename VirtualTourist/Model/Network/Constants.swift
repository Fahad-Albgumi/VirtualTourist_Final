//
//  Constants.swift
//  VirtualTourist
//
//  Created by fahad on 09/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//
import Foundation

struct APIConstants {
    
    struct HeaderValues {
        static let API_KEY = "8b8a57016e253f21954b50e176490c35"
        static let API_SECRET = "dee2971f4f20d803"
        static let METHOD = "flickr.photos.search"
        static let FORMAT = "json"
        static let ACCURACY = "11"

    }
    
     static let MAIN = "https://api.flickr.com/services/rest"
//    static let SESSION = MAIN + "/v1/session"
//    static let PUBLIC_USER = MAIN + "/v1/users/"
//    static let STUDENT_LOCATION = MAIN + "/v1/StudentLocation"
    
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
