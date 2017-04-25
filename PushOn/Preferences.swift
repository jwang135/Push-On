//
//  Preferences.swift
//  PushOn
//
//  Created by Rishil on 4/14/17.
//  Copyright © 2017 Rishil Mehta. All rights reserved.
//

import Foundation

class Preferences: NSObject, NSCoding {
    
    var animals : Set<String>
    var tvShows : Set<String>
    var otherCuteThings : Set<String>
    var additionalMotivators : Set<String>
    let NUMBEROFCATEGORIES : Int = 4
    var prefersDistractions : Bool
//    var sliderValue : Float
    
    init(animals: Set<String> = ["Dog"], tvShows : Set<String> = [], otherCuteThings : Set<String> = [], additionalMotivators : Set<String> = [], prefersDistractions : Bool = false) {
        
        self.animals = animals
        self.tvShows = tvShows
        self.otherCuteThings = otherCuteThings
        self.additionalMotivators = additionalMotivators
        self.prefersDistractions = prefersDistractions
//        self.sliderValue = sliderValue
        
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let animals = aDecoder.decodeObject(forKey: "animals") as! Set<String>
        let tvShows = aDecoder.decodeObject(forKey: "tvShows") as! Set<String>
        let otherCuteThings = aDecoder.decodeObject(forKey: "otherCuteThings") as! Set<String>
        let additionalMotivators = aDecoder.decodeObject(forKey: "additionalMotivators") as! Set<String>
        let prefersDistractions = aDecoder.decodeBool(forKey: "prefersDistractions")
//        let sliderValue = aDecoder.decodeFloat(forKey: "sliderValue")
        
        self.init(animals: animals, tvShows: tvShows, otherCuteThings: otherCuteThings, additionalMotivators: additionalMotivators, prefersDistractions: prefersDistractions)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(animals, forKey: "animals")
        aCoder.encode(tvShows, forKey: "tvShows")
        aCoder.encode(otherCuteThings, forKey: "otherCuteThings")
        aCoder.encode(additionalMotivators, forKey: "additionalMotivators")
        aCoder.encode(prefersDistractions, forKey: "prefersDistractions")
//        aCoder.encode(sliderValue, forKey: "sliderValue")

    }
    
//    func updateSliderValue(newVal: Float) {
//        sliderValue = newVal
//    }
    
    
}
