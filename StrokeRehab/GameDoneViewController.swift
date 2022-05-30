//
//  GameDoneViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 30/5/2022.
//

import UIKit

class GameDoneViewController: UIViewController {
    
    var isFreeMode = false
    var gameGoalType = Exercise.GoalType.repetition.rawValue
    var gameStartAt : String = ""
    var gameEndAt : String = ""
    var repeNumber : Int = 0
    var timeLimit : Int = 0
    var timeTakenForRepe : Int = 0
    var repeNumForTimeLimit : Int = 0
    
    var gameFinishInfor : Exercise?
    


    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var gameModeLabel: UILabel!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var repeNumLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let freeMode = self.gameFinishInfor!.isFreeMode
        
        startTimeLabel.text = gameStartAt
        endTimeLabel.text = gameEndAt
        gameModeLabel.text = freeMode ? "Free Mode" : "Goal Mode"
        goalTypeLabel.text = gameGoalType == Const.GoalType.repetition.rawValue ? "\(repeNumber)   Repetitions" : "\(timeLimit) Seconds Time Limit"
        repeNumLabel.text = String(repeNumber)
        timeTakenLabel.text = String(timeTakenForRepe)
        
//        Exercise.GoalType.repetition
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
