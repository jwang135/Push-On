//
//  Extensions.swift
//  PushOn
//
//  Created by Rishil on 4/14/17.
//  Copyright © 2017 Rishil Mehta. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        do {
            let data = try Data(contentsOf: url)
            return JSON(data: data)
        } catch {
            return JSON.null
        }
    }
    
    func savePreferences(prefs : Preferences) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: prefs)
        userDefaults.set(encodedData, forKey: "preferences")
        userDefaults.synchronize()
    }
    
    func loadPreferences() -> Preferences {
        let userDefaults = UserDefaults.standard
        let decoded = userDefaults.object(forKey: "preferences") as? Data ?? Data()
        let decodedPreferences = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Preferences ?? Preferences(animals: ["Dogs"], tvShows: ["The Office"], otherCuteThings: [], additionalMotivators: [], prefersDistractions: true)
        
        userDefaults.synchronize()
        return decodedPreferences
    }
    
}

extension Set {
    public func randomObject() -> Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] : nil
    }
}

