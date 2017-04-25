//
//  ViewController.swift
//  PushOn
//
//  Created by Rishil on 4/14/17.
//  Copyright © 2017 Rishil Mehta. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController {
    
    var prefs: Preferences = Preferences(animals: ["Dogs"], tvShows: ["The Office"], otherCuteThings: [], additionalMotivators: [], prefersDistractions: true)
    
    
    let SEARCH_URL = "http://api.forismatic.com/api/1.0/?method=getQuote&key=457652&format=json&lang=en"
    
    var tenor:Bool = true
    
    let defaults = UserDefaults.standard

    let ANIMALKEYWORD = "cute"
    let TVSHOWKEYWORD = "hilarious"
    let OTHERCUTETHINGSKEYWORD = ""
    let ADDITIONALMOTIVATORSKEYWORD = "inspirational"
    
    // Giphy currently unimplemented:
    // SwiftyJSON unable to parse JSON
    var giphy:Bool = false
    
    //Timing variables
    var last : TimeInterval = 0
    var secondsTilNextNotification : TimeInterval = 0
    
    var timer: Timer!
    
    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var gif: UIImageView!
    
    @IBOutlet weak var quote: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var stressSlider: UISlider!
    
    @IBOutlet weak var stressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefs = loadPreferences()

        
        //sets notification actions
        let center = UNUserNotificationCenter.current()
        let accept = UNNotificationAction.init(identifier: "Accept",
                                               title: "Accept",
                                               options: UNNotificationActionOptions.foreground)
        let cancel = UNNotificationAction.init(identifier: "Cancel",
                                               title: "Cancel",
                                               options: UNNotificationActionOptions.destructive)
        let actions = [ accept, cancel ]
        
        // create a category with the actions above
        let inviteCategory = UNNotificationCategory(identifier: "com.MehtaKnight.PushOn", actions: actions, intentIdentifiers: [], options: [])
        // registration must happen in viewdidload
        center.setNotificationCategories([ inviteCategory ])
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }

        
        //Update stressSlider to the correct color and position
        stressSlider.value = defaults.object(forKey: "stressLvl") as? Float ?? 0.5
        let color = getStressHSB(sliderVal: stressSlider.value)
        stressLabel.text = stressText(sliderVal: stressSlider.value)
        stressSlider.minimumTrackTintColor = color
        stressLabel.textColor = color
        
        //Obtain a quote and gif
        repeat {
            getQuote()
        } while (quote.text == "" || author.text == " - ")
        print(getSearchQuery())
        gif.image = getData(search: getSearchQuery())
        
        startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prefs = loadPreferences()
        print("First animal in prefs: \(prefs.animals.first)")
    }
    
    
    // MARK: TIMER FUNCTIONS
    
    func startTimer() {
        
        let yesOrNo = !prefs.prefersDistractions
        var interval = (23*3600*Double(stressSlider.value) + 3600)/1000
        
        if(yesOrNo){
            print("YES OR NO IS ON")
            interval = (23*3600*Double(stressSlider.value) + 3600)/1000
            //The division by 1000 is for demoing purposes
        }
        else{
            interval = (23 * 3600.0 * Double(1-stressSlider.value)  + 3600)/1000
            //the division by 1000 is for demoing purposes
        }
        
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        
        print("interval in start time: \(interval)")
    }
    
    
    func updateTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: secondsTilNextNotification, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
            print(secondsTilNextNotification)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
    }
    
    //sends local notifications
    func notify(){
        print("notify")
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: "You have a new motivational message", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        content.categoryIdentifier = "com.MehtaKnight.PushOn"
        
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60, repeats: true)
        UNNotificationTrigger.initialize()
        
        //let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: nil)
        
        // Schedule the notification.
//        let center = UNUserNotificationCenter.current()
//        center.add(request)
    }
    
    func refresh() {
        self.getQuote()
        
        self.gif.image = self.getData(search: self.getSearchQuery())
        self.notify()
        
    }
    
    
    func getQuote() {
        
        
        DispatchQueue.global().async {
            
            let url = self.SEARCH_URL
            
            var result: JSON
            
            var quoteString : String
            var authorString : String
            
            repeat {
                
                result = self.getJSON(path: url)
                
                
            
                quoteString = result["quoteText"].stringValue
                authorString = result["quoteAuthor"].stringValue
                
            } while (quoteString == "")
            
            //print(result)
            
            DispatchQueue.main.async {
                
                if result["Error"] == "Movie not found!" {
                    
                    print("error")
                } else {
                    print(quoteString )
                    
                    print("no error")
                    self.quote.text = "\"\(quoteString)\""
                    self.author.text = " - \(authorString)"
                    
                }
                
                
            }
            
        }
        
        
    }
    
    
    func getData (search:String) -> UIImage? {
        
        
        let friendlySearch = search.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        
        if(giphy) {
            
            //Public Beta key
            let key:String = "dc6zaTOxFJmzC"
            
            var path:String = "http://api.giphy.com/v1/gifs/search?q=" + friendlySearch + "&api_key=" + key
            
            var data = (getJSON(path: path))
            
            let number = String(arc4random_uniform(100))
            path = "http://api.giphy.com/v1/gifs/search?q=" + friendlySearch + "&api_key=" + key + "+&fmt=json&limit=1&offset=" + number
            
            data = (getJSON(path: path))
            
            print(path)
            print(data)
            
        }
        else if(tenor) {
            
            //Sample key
            let key:String = "LIVDSRZULELA"
            
            let path:String = "https://api.tenor.co/v1/search?key=" + key + "&tag=" + friendlySearch
            
            let data = (getJSON(path: path))
            let count:UInt32 = UInt32(data["results"].count)
            let index = Int(arc4random_uniform(count))
            
            if let imageUrl = data["results"][index]["media"][0]["gif"]["url"].string {
                let image = UIImage.gif(url: imageUrl)
                
                return image
            }
            
            
            
        }
        
        return nil
        
    }
    
    @IBAction func calcValue(_ sender: UISlider) {
        let yesOrNo = !prefs.prefersDistractions
        
        //var secondsTilNextNotification : TimeInterval = 0
        
        let color = getStressHSB(sliderVal: stressSlider.value)
        
        stressSlider.minimumTrackTintColor = color
        stressLabel.textColor = color
        defaults.set(stressSlider.value, forKey: "stressLvl")
        stressLabel.text = stressText(sliderVal: stressSlider.value)
        
        
        if(yesOrNo){
            print("YES OR NO IS ON")
            secondsTilNextNotification = (23*3600*Double(stressSlider.value) + 3600)/1000
            //The division by 1000 is for demoing purposes
        }
        else{
            secondsTilNextNotification = (23 * 3600.0 * Double(1-stressSlider.value)  + 3600)/1000
            //the division by 1000 is for demoing purposes
        }
        
        print("Stress slider: \(stressSlider.value)")
        print("\(secondsTilNextNotification) is the number of seconds remaining until next notification")
        stopTimer()
        updateTimer()
        
    }
    
    func getStressHSB(sliderVal: Float) -> UIColor {
    
        let hue = (120 * (1 - Double(sliderVal))) / 255.0
        let sat = 0.8
        let bright = 0.8
        let alpha = 1.0
        
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(sat), brightness: CGFloat(bright), alpha: CGFloat(alpha))
    }
    
    func stressText(sliderVal: Float) -> String {
        
        switch sliderVal {
        case 0..<0.2:
            return "Chill"
        case 0.2..<0.4:
            return "Ok"
        case 0.4..<0.6:
            return "Kinda stressed"
        case 0.6..<0.8:
            return "Stressed"
        case 0.8...1.0:
            return "Really stressed"
        default:
            return "How did I get here?"
        }
        
        
    }
    
    func printPrefs() {
        
        for item in prefs.animals {
            print("heres another animal in the struct: \(item)")
        }
        for item in prefs.tvShows {
            print("heres another tv show in the struct: \(item)")
        }
        for item in prefs.otherCuteThings {
            print("heres another otherCute in the struct: \(item)")
        }
        for item in prefs.additionalMotivators {
            print("heres another add. motiv. in the struct: \(item)")
        }
    }
    
    func getSearchQuery() -> String {
        //Uses the global preferences object to determine what search query to deliver to the gif
        //number of categories is hardcoded. TODO PLS FIX
        
        let availableCategories = appendExistingCategories() ?? [0]
        
        let randomCategoryValue : UInt32 = arc4random_uniform(UInt32(availableCategories.count))
        
        //printPrefs()
        
        let category: Set<String>
        let keyword: String
        print("Random category value is \(randomCategoryValue)")
        print("The index of the category is: \(availableCategories[Int(randomCategoryValue)])")
        
        switch availableCategories[Int(randomCategoryValue)] {
        case 0:
            category = prefs.animals
            keyword = ANIMALKEYWORD
        case 1:
            category = prefs.tvShows
            keyword = TVSHOWKEYWORD
        case 2:
            category = prefs.otherCuteThings
            keyword = OTHERCUTETHINGSKEYWORD
        case 3:
            category = prefs.additionalMotivators
            keyword = ADDITIONALMOTIVATORSKEYWORD
        default:
            category = prefs.animals
            keyword = ANIMALKEYWORD
        }
        
        let searchTuple : (Set<String>, String) = (category, keyword)
        
        let randomQuery : String = searchTuple.0.randomObject() ?? ""
        
        let searchQuery = "\(searchTuple.1) \(randomQuery)"
        print("search query to use is: \(searchQuery)")
        
        return searchQuery
    }

    
    
    func appendExistingCategories() -> [Int]? {
        
        //This is the hackiest possible way to deal with this issue
        
        var array : [Int] = []
        if (!prefs.animals.isEmpty) {
            array.append(0)
        }
        if (!prefs.tvShows.isEmpty) {
            array.append(1)
        }
        if (!prefs.otherCuteThings.isEmpty) {
           array.append(2)
        }
        if (!prefs.additionalMotivators.isEmpty) {
            array.append(3)
        }
        return array
    }

    
    
    
    
   

}

