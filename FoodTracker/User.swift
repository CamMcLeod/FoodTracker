//
//  User.swift
//  FoodTracker
//
//  Created by Cameron Mcleod on 2019-07-08.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation


struct User : Codable {
    
    var id : Int
    var username : String
    var password : String
    var token  : String

}
