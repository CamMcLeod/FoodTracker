//
//  Meal.swift
//  FoodTracker
//
//  Created by Cameron Mcleod on 2019-07-08.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation
import UIKit
import os.log


class Meal: NSObject, NSCoding {
    
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var calories: Int
    var mealDescription: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let calories = "calories"
        static let mealDescription = "mealDescription"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int, calories: Int, mealDescription: String?) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // The calories must be nonnegative
        guard (calories >= 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.calories = calories
        self.mealDescription = ""
        
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(calories, forKey: PropertyKey.calories)
        aCoder.encode(mealDescription, forKey: PropertyKey.mealDescription)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let calories = aDecoder.decodeInteger(forKey: PropertyKey.calories)
        
        
        
        guard let mealDescription = aDecoder.decodeObject(forKey: PropertyKey.mealDescription) as? String else {
            os_log("Unable to decode the description for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, calories: calories, mealDescription: mealDescription)
        
    }
}
