//
//  ViewController.swift
//  pomodoro-app
//
//  Created by Mudit Verma on 6/10/21.
//

import UIKit
import AudioToolbox
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var focusModeButton: UIButton!
    @IBOutlet weak var breakModeButton: UIButton!
    
    @IBOutlet weak var ModeLabel: UILabel!
    
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    var timerModeLimit:Int = 10
    
    let timerBreakModeLimit = 3
    let timerFocusModeLimit = 10
    
    let BREAKMODE = 0
    let FOCUSMODE = 1
    
    // 0 for breakmode, 1 for focus mode.
    
    var timerMode = 1
    
//    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        self.updateTimerMode(newmode: FOCUSMODE)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            // we can use granted to interact with user here.
        }

    }
    
    func buildModeNotification(){
        var title   = ""
        var body    = ""

        let current_mode = self.timerMode
        
        if (current_mode == self.BREAKMODE){
            title   = "Break is Over!"
            body    = "Get back to your tasks, start Focus timer in the app"
            
        }else if (current_mode == self.FOCUSMODE){
            title   = "Take a Break!"
            body    = "You've earned it. Start Break timer in the app"
        }
        
        self.buildNotification(title: title, body: body, delaytime: 3)
    }
    


    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you want to reset the Timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            // do nothing
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.resetTimer()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
     
    

    @IBAction func breakModeButtonTapped(_ sender: Any) {
        self.updateTimerMode(newmode: self.BREAKMODE)
        if(timerCounting){
            stopTimer()
        }else {
            // AudioServicesPlaySystemSound(4095)
            startTimer()
        }
    }
    
    @IBAction func focusModeButtonTapped(_ sender: Any) {
        self.updateTimerMode(newmode: self.FOCUSMODE)
        if(timerCounting){
            stopTimer()
            
        }else {
            startTimer()
        }
    }
    
 
    
    @IBAction func startStopTapped(_ sender: Any) {
        if(timerCounting){
            stopTimer()
        }else {
            startTimer()
        }
    }
    
    
    func stopTimer() -> Void {
        self.timerCounting = false
        self.timer.invalidate()
        self.startStopButton.setTitle("START", for: .normal)
        self.startStopButton.setTitleColor(UIColor.green, for: .normal)
        self.resetColorScheme()
    }
    
    func startTimer() -> Void{
        self.setColorSchemeByMode()
        self.timerCounting = true
        self.startStopButton.setTitle("STOP", for: .normal)
        self.startStopButton.setTitleColor(UIColor.red, for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func resetTimer()->Void{
        self.count = 0
        self.timer.invalidate()
        self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        self.startStopButton.setTitle("START", for: .normal)
        self.startStopButton.setTitleColor(UIColor.green, for: .normal)
        self.resetColorScheme()
        self.timerCounting = false
    }
    
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondstoHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        TimerLabel.text = timeString
        
        if(count == self.timerModeLimit){
            self.buildModeNotification()
            self.resetTimer()
        }
    }
    
    func secondstoHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return ((seconds / 3600), (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func makeTimeString(hours : Int, minutes : Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String (format : "%02d", hours)
        timeString += " : "
        timeString += String (format : "%02d", minutes)
        timeString += " : "
        timeString += String (format : "%02d", seconds)

        return timeString
    }
    
    func updateTimerMode(newmode : Int) -> Void{
        self.count = 0
        self.timerMode = newmode
        if (newmode == self.BREAKMODE){
            self.timerModeLimit = self.timerBreakModeLimit
            self.ModeLabel.text = "Break Time"
            
        }else if (newmode == self.FOCUSMODE){
            self.timerModeLimit = self.timerFocusModeLimit
            self.ModeLabel.text = "Focus Time"
        }
    }
    

    func setColorSchemeByMode() -> Void{
        let currentMode = self.timerMode
        
        if (currentMode == self.BREAKMODE) {
            self.view.backgroundColor = UIColor.orange
            self.TimerLabel.textColor = UIColor.white
            self.ModeLabel.textColor = UIColor.white
            
        } else if (currentMode == self.FOCUSMODE) {
            self.view.backgroundColor = UIColor.black
            self.TimerLabel.textColor = UIColor.white
            self.ModeLabel.textColor = UIColor.white
        }
        
    }
    
    func resetColorScheme() -> Void {
        self.view.backgroundColor = UIColor.white
        self.TimerLabel.textColor = UIColor.black
        self.ModeLabel.textColor = UIColor.black
    }
    
    func buildNotification(title:String, body:String, delaytime: Double){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let date = Date().addingTimeInterval(delaytime)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

