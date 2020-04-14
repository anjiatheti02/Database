//
//  Server.swift
//  Database
//
//  Created by Admin on 19/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class Server {
    
    static let shared = Server()
    
    static func getRequest(url:String, jsonHandler: @escaping (_ result: [String:Any]?, _ dataerror: Error?)->()){
        
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]{
                        jsonHandler(json, nil)
                    }
                }catch {
                    jsonHandler(nil, error)
                }
            }
            }.resume()
    }
    
    static func postRequest(params:[String:String], url:String, jsonHandler: @escaping (_ result: [String:Any]?, _ dataerror: Error?)->()){
        
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]{
                        jsonHandler(json, nil)
                    }
                    
                }catch {
                    jsonHandler(nil, error)
                }
            }
            }.resume()
    }
    
}
