//
//  CloudTrackerAPI .swift
//  FoodTracker
//
//  Created by Cameron Mcleod on 2019-07-08.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation
import UIKit
import os.log


class CloudTrackerAPI {
    
    
    func userLogin(username: String?, password: String?, newUser: Bool, completion: @escaping (User?) -> Void)  {
        
        var user : User? = nil
        let endpoint : String
        
        let postData = [
            "username": username ?? "",
            "password": password ?? ""
        ]
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options : []) else {
            print("could not serialize json")
            completion(user)
            return
        }
        if newUser {
            endpoint = "signup"
        } else {
            endpoint = "login"
        }
        
        let url = URL(string: "https://cloud-tracker.herokuapp.com/\(endpoint)")!
        let request = NSMutableURLRequest(url: url)
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                print("no data returned from server \(String(describing: error?.localizedDescription))")
                completion(user)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any> else {
                print("data returned is not json, or not valid")
                completion(user)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("no response returned from server \(String(describing: error))")
                completion(user)
                return
            }
            
            guard response.statusCode == 200 else {
                // handle error
                print("an error occurred \(String(describing: json["error"]))")
                completion(user)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                user = try decoder.decode(User.self, from: data)
            } catch {
                print("Failed to decode JSON")
                completion(user)
                return
            }
            
            DispatchQueue.main.async {
                completion(user)
            }
            
            
            
        }
        
        // do something with the json object
        task.resume()
        
    }
    
}
