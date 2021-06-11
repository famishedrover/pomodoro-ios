//
//  ViewController.swift
//  pomodoro-app
//
//  Created by Mudit Verma on 6/10/21.
//

import UIKit

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
    
    let timerBreakModeLimit = 2
    let timerFocusModeLimit = 5
    
    let BREAKMODE = 0
    let FOCUSMODE = 1
    
    // 0 for breakmode, 1 for focus mode.
    
    var timerMode = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        self.updateTimerMode(newmode: FOCUSMODE)
    }

    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you want to reset the Timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            // do nothing
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
     
    

    @IBAction func breakModeButtonTapped(_ sender: Any) {
        self.updateTimerMode(newmode: self.BREAKMODE)
        if(timerCounting){
            stopTimer()
        }else {
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
    }
    
    func startTimer() -> Void{
        self.timerCounting = true
        self.startStopButton.setTitle("STOP", for: .normal)
        self.startStopButton.setTitleColor(UIColor.red, for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondstoHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        TimerLabel.text = timeString
        
        if(count == self.timerModeLimit){
            self.stopTimer()
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
    
    
}

