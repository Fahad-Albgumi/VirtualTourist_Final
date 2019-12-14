//
//  API.swift
//  VirtualTourist
//
//  Created by fahad on 09/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import Foundation
import Kingfisher
import SwiftyJSON
import Alamofire

class Connectivity {
    static var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    enum Status {
        case notConnected, connected, other
    }
}

class API {
    
    static func getListOfPhotosIn(lat: Double, lon: Double, completionHandler: @escaping (Connectivity.Status, [String]?) -> Void) {
        let url = "\(APIConstants.MAIN)?api_key=\(APIConstants.HeaderValues.API_KEY)&method=\(APIConstants.HeaderValues.METHOD)&per_page=\(25)&format=json&nojsoncallback=?&lat=\(lat)&lon=\(lon)&page=\((1...5).randomElement() ?? 1)"
        
        if !Connectivity.isConnectedToInternet {
            completionHandler(.notConnected, nil)
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if((response.result.value) != nil) {
                print(response)
                
                let swiftyJsonVar = JSON(response.result.value!)
                var photosURL: [String] = []
                
                if let photos = swiftyJsonVar["photos"]["photo"].array {
                    for photo in photos {
                        let photoURL = "https://farm\(photo["farm"].stringValue).staticflickr.com/\(photo["server"].stringValue)/\(photo["id"])_\(photo["secret"]).jpg"
                        photosURL.append(photoURL)
                    }
                }
                completionHandler(.connected, photosURL)
            } else {
                completionHandler(.other, nil)
            }
        }
        
    }
    //        let modifier = AnyModifier { request in
    //            var r = request
    //            r.setValue(APIConstants.HeaderValues.API_KEY, forHTTPHeaderField: "api_key")
    //            r.setValue(APIConstants.HeaderValues.METHOD, forHTTPHeaderField: "method")
    //            r.setValue(APIConstants.HeaderValues.FORMAT, forHTTPHeaderField: "format")
    //            r.setValue(APIConstants.HeaderValues.ACCURACY, forHTTPHeaderField: "accuracy")
    //            r.setValue("34.08626093290022", forHTTPHeaderField: "latitude")
    //            r.setValue("-118.24174458145848", forHTTPHeaderField: "longitude")
    //            return r
    //        }
    //        let downloader = ImageDownloader.default
    //        downloader.downloadImage(with: url, options: [.requestModifier(modifier)]) {
    //            result in
    //            print(result)
    //            // ...
    //        }
    //        let session = URLSession.shared
    //        let task = session.dataTask(with: request) { data, response, error in
    //            if let code = (response as? HTTPURLResponse)?.statusCode {
    //                if code >= 200 && code < 300 {
    //                    let range: CountableRange = 5..<data!.count
    //                    let newData = data?.subdata(in: range) /* subset response data! */
    //                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
    //                        let dict = json as? [String:Any],
    //                        let sessionDict = dict["session"] as? [String: Any],
    //                        let accountDict = dict["account"] as? [String: Any]  {
    //                        self.accountInfo.key = accountDict["key"] as? String // This is used in getUserInfo(completion:)
    //                        self.sessionId = sessionDict["id"] as? String
    //
    //                        self.getUserInfo(completion: { err in
    //
    //                        })
    //                    } else {
    //                        errorString = "Cant find response"
    //                    }
    //                } else {
    //                    errorString = "login credintials are not correct"
    //                }
    //            } else {
    //                errorString = "Check your internet connection"
    //            }
    //            DispatchQueue.main.async {
    //                completion(errorString)
    //            }
    //
    //        }
    //        task.resume()
}

