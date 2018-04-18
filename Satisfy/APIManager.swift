//
//  APIManager.swift
//  Satisfy
//
//  Created by Pierre on 17/04/2018.
//  Copyright © 2018 boudonpierre. All rights reserved.
//

import UIKit

class APIManager {
    var delegate: APIManagerDelegate?
    static var shared = APIManager()
    var vm = ViewModel()
    
    fileprivate func getRequest(route: String) {
        var request = URLRequest(url: URL(string: route)!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let realResponse = response as! HTTPURLResponse
            
            if let d = self.delegate {
                d.getCallback!(statusCode: realResponse.statusCode, data: data!)
            }
        }).resume()
    }
}

extension APIManager {
    public func getInfos() {
        let route = "https://satisfyapi.herokuapp.com/api/satisfaction"
        
        self.getRequest(route: route)
    }
}

@objc protocol APIManagerDelegate {
    @objc optional func getCallback(statusCode: Int, data: Data)
}
