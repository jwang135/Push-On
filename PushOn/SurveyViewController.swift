//
//  SurveyViewController.swift
//  PushOn
//
//  Created by Rishil on 4/19/17.
//  Copyright © 2017 Rishil Mehta. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var theCollectionView: UICollectionView!
    
    @IBOutlet weak var theSwitch: UISwitch!
    
    //Hardcoded
    var preferences = [
        "Animals" : [
            [
                "name" : "Dogs",
                "image" : #imageLiteral(resourceName: "dog"),
                "selected"  : false
    
            ],
            [
                "name" : "Cats",
                "image" : #imageLiteral(resourceName: "cat"),
                "selected"  : false
                
            ],
            [
                "name" : "Bunnies",
                "image" : #imageLiteral(resourceName: "bunny"),
                "selected"  : false
                
            ],
            [
                "name" : "Alpacas",
                "image" : #imageLiteral(resourceName: "alpaca"),
                "selected"  : false
                
            ],
            [
                "name" : "Woodland Creatures",
                "image" : #imageLiteral(resourceName: "woodland"),
                "selected"  : false
                
            ],
            [
                "name" : "Sloths",
                "image" : #imageLiteral(resourceName: "sloth"),
                "selected"  : false
                
            ]
        
        ],
        
        "TV Shows" : [
            [
                "name" : "The Office",
                "image" : #imageLiteral(resourceName: "office"),
                "selected"  : false
                
            ],
            [
                "name" : "How I Met Your Mother",
                "image" : #imageLiteral(resourceName: "himym"),
                "selected"  : false
                
            ],
            [
                "name" : "Big Bang Theory",
                "image" : #imageLiteral(resourceName: "bbt"),
                "selected"  : false
                
            ],
            [
                "name" : "Spongebob",
                "image" : #imageLiteral(resourceName: "spongebob"),
                "selected"  : false
                
            ],
            [
                "name" : "Bob Ross",
                "image" : #imageLiteral(resourceName: "bobross"),
                "selected"  : false
                
            ],
            [
                "name" : "Parks and Rec",
                "image" : #imageLiteral(resourceName: "food"),
                "selected"  : false
                
            ]
            
        ],
        
        "Other cute things" : [
            [
                "name" : "Babies",
                "image" : #imageLiteral(resourceName: "baby"),
                "selected"  : false
                
            ],
            [
                "name" : "Charity",
                "image" : #imageLiteral(resourceName: "charity"),
                "selected"  : false
                
            ]
        ],
        
        "Additional Motivators" : [
            [
                "name" : "Nature",
                "image" : #imageLiteral(resourceName: "nature"),
                "selected"  : false
                
            ],
            [
                "name" : "Grades",
                "image" : #imageLiteral(resourceName: "grades"),
                "selected"  : false
                
            ],
            [
                "name" : "Sleep",
                "image" : #imageLiteral(resourceName: "image"),
                "selected"  : false
                
            ],
            [
                "name" : "Food",
                "image" : #imageLiteral(resourceName: "food"),
                "selected"  : false
                
            ]
        ]
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     savePreferences(prefs: Preferences())
        let prefs = loadPreferences()
        loadPreferencesFromStruct(prefs: prefs)
        theSwitch.isOn = prefs.prefersDistractions
        
       theCollectionView.delegate = self
        theCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTypeFromSection(section : Int) -> String {
        switch section {
        case 0: return "Animals"
        case 1: return "TV Shows"
        case 2: return "Other cute things"
        case 3: return "Additional Motivators"
        default: return "IMPOSSIBLE"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionName = getTypeFromSection(section: section)
        
        return preferences[sectionName]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = theCollectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveyCollectionViewCell
        let sectionName = getTypeFromSection(section: indexPath.section)
        let name = preferences[sectionName]![indexPath.row]["name"] as! String
        let image = preferences[sectionName]![indexPath.row]["image"] as! UIImage
        cell.name.text = name
        cell.image.image = image
        cell.name.layer.shadowPath = UIBezierPath(rect: cell.name.layer.bounds).cgPath
        cell.name.layer.shadowRadius = 10
        cell.name.layer.shadowOpacity = 0.5
        
        let selected = preferences[sectionName]![indexPath.row]["selected"] as! Bool
        if(selected) {
            cell.filter.isHidden = false
        } else {
            cell.filter.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath as IndexPath) as! SectionHeaderCollectionReusableView
        let type = getTypeFromSection(section: indexPath.section)
        header.headerLabel.text = type
        return header
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return preferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = getTypeFromSection(section: indexPath.section)
        preferences[type]![indexPath.row]["selected"] = toggle(value: preferences[type]![indexPath.row]["selected"] as! Bool)
        theCollectionView.reloadData()
        print("got here and selected is \(preferences[type]![indexPath.row]["selected"])")
        let prefs = createStructFromPreferences(preferences: preferences)
        savePreferences(prefs: prefs)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func toggle(value: Bool) -> Bool {
        return !value
    }
    
    func createStructFromPreferences(preferences : [String : Array<Dictionary<String, Any>>]) -> Preferences {
        
        var animals : Set<String> = []
        var tvShows : Set<String> = []
        var otherCuteThings : Set<String> = []
        var additionalMotivators : Set<String> = []
        
        let animalsDict = preferences["Animals"]!
        for animal in animalsDict {
            if(animal["selected"] as! Bool == true) {
                animals.insert(animal["name"] as! String)
            }
        }
        let tvShowsDict = preferences["TV Shows"]!
        for show in tvShowsDict {
            if(show["selected"] as! Bool == true) {
                tvShows.insert(show["name"] as! String)
            }
        }
        let otherDict = preferences["Other cute things"]!
        for other in otherDict {
            if(other["selected"] as! Bool == true) {
                otherCuteThings.insert(other["name"] as! String)
            }
        }
        let additionalDict = preferences["Additional Motivators"]!
        for additional in additionalDict {
            if(additional["selected"] as! Bool == true) {
                additionalMotivators.insert(additional["name"] as! String)
            }
        }
        
        return Preferences(animals: animals, tvShows: tvShows, otherCuteThings: otherCuteThings, additionalMotivators: additionalMotivators, prefersDistractions: theSwitch.isOn)
        
    }
    
    func loadPreferencesFromStruct(prefs: Preferences) {
        let animals = prefs.animals
        let tvShows = prefs.tvShows
        let otherCuteThings = prefs.otherCuteThings
        let additionalMotivators = prefs.additionalMotivators
        
        for animal in animals {
            for (index, item) in preferences["Animals"]!.enumerated() {
                if(item["name"] as! String == animal) {
                    preferences["Animals"]![index]["selected"] = true
                }
            }
        }
        for show in tvShows {
            for (index, item) in preferences["TV Shows"]!.enumerated() {
                if(item["name"] as! String == show) {
                    preferences["TV Shows"]![index]["selected"] = true
                }
            }
        }
        for other in otherCuteThings {
            for (index, item) in preferences["Other cute things"]!.enumerated() {
                if(item["name"] as! String == other) {
                    preferences["Other cute things"]![index]["selected"] = true
                }
            }
        }
        for additional in additionalMotivators {
            for (index, item) in preferences["Additional Motivators"]!.enumerated() {
                if(item["name"] as! String == additional) {
                    preferences["Additional Motivators"]![index]["selected"] = true
                }
            }
        }
        
    }
    

    @IBAction func switchToggled(_ sender: Any) {
        let prefs = createStructFromPreferences(preferences: preferences)
        savePreferences(prefs: prefs)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
