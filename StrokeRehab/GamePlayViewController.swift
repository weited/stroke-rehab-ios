//
//  GamePlayViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 28/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class GamePlayViewController: UIViewController {
    
    var repeNum : Int = 1
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 2
    var timeLimit : Int = 0
    var isCompleted : Bool = false
    
    var docId : String = ""
    var gameStartAt : String = ""
    var gameEndAt : String = ""
    var timeTakenForRepe : Int = 0
    
    var targetBtns : [Int] = [1,2,3]
    var randomBtns : [Int] = [2,1,3]
    
    var currentBtn : Int = 1
    var roundDone : Int = 0
    
    var btnUIGroup : [UIButton] = []
    var isOverlap : Bool = false
    
    var goalType : String = Exercise.GoalType.repetition.rawValue
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.title = "New title"
        gameStartAt = getTimeStamp()
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForRepetition), userInfo: nil, repeats: true)
        
        self.docId = getTimeStamp(format: "gameId")
        print("###############: \(Exercise.GoalType.repetition)")
        
        // create an empty document
        createGameDoc()
        
        //        let thisGame = Exercise(id: "tisisldk", repetition: 123, completed: false, startAt: "dafa", endAt: "da", btnPressed: ["2":2], photoPath: "fkafa")
        //
        //        thisGame.createGameDoc()
        
        for index in 1...btnNum {
            btnAreaView.layoutIfNeeded()
            let height = btnAreaView!.frame.size.height - 50
            let width = btnAreaView!.frame.size.width - 50
            print("size is \(height)")
            print("size is \(width)")
            //            let button = UIButton(frame: CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50))
            
            let button = UIButton()
            
            
            button.layer.cornerRadius = 25
            
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonDownAction), for: .touchDown)
            button.addTarget(self, action: #selector(buttonReleaseAction), for: .touchUpInside)
            
            button.tag = index
            
            btnAreaView.addSubview(button)
            
            btnUIGroup.append(button)
            
            
        }
        
        print("is over lap before while? \(isOverlap)")
        
        // random button position first then check if overlap
        repeat
        {
            print("before repeat? \(isOverlap)")
            randomPosition()
            checkBtnOverlap(btnGroup: btnUIGroup)
            print("after repeat? \(isOverlap)")
        }
        while isOverlap == true
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        print("stop timer")
    }
    
    @objc func timerForRepetition() {
        timeTakenForRepe += 1
        self.title = String(timeTakenForRepe)
    }
    
    @objc func timerForTimeLimit() {
        timeLimit -= 1
        self.title = String(timeLimit)
        if timeLimit == 0 {
            timer.invalidate()
        }
        
    }
    
    @objc func buttonDownAction(sender: UIButton!) {
        if sender.tag != currentBtn {
            sender.setTitle("X", for: .normal)
            sender.backgroundColor = Const.BtnColors.wrong
        }
    }
    
    @objc func buttonReleaseAction(sender: UIButton!) {
        if sender.tag == currentBtn-1 {
            sender.setTitle("✓", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        } else {
            sender.setTitle("\(sender.tag)", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        }
    }

    
    @objc func buttonAction(sender: UIButton!) {
        print("Current Button \(currentBtn)")
        print("Button tapped\(sender.tag)")
        Exercise.addBtnPressedToDB(documentId: docId, btnPressed: [getTimeStamp():sender.tag])
        
        if sender.tag == currentBtn {
            sender.setTitle("✓", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
            if currentBtn < btnNum {
                btnUIGroup[currentBtn].backgroundColor = Const.BtnColors.indicator
//                btnUIGroup[currentBtn].layer.borderColor = .init(gray: 2, alpha: 1)
            }
            currentBtn += 1
            
            // Completed a round, Reset first btn, increase rounds
            if currentBtn > btnNum {
                currentBtn = 1
                roundDone += 1
                
                // Finish Game and Nav to next UI
                if roundDone == repeNum {
                    completeGame()
                    print("You finished!")
                    return
                }
                
                // Random position if btn overlap
                repeat
                {
                    randomPosition()
                    checkBtnOverlap(btnGroup: btnUIGroup)
                }
                while isOverlap == true
            }
        }
    }
    
    func checkBtnOverlap(btnGroup: [UIButton]) {
        //        for index in 1...btnNum {var button = btnAreaView.viewWithTag(index) as? UIButton}
        //        var isOverlap : Bool = false
        print("is over lap? \(isOverlap)")
        for i in 0..<btnNum {
            if isOverlap == true {
                break
            } else {
                for j in i+1..<btnNum {
                    if btnGroup[i].frame.intersects(btnGroup[j].frame) {
                        isOverlap = true
                        break
                    }
                }
            }
        }
    }
    
    func randomPosition() {
        let height = btnAreaView!.frame.size.height - 50
        let width = btnAreaView!.frame.size.width - 50
        
        for index in 1...btnNum {
            //            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50)
            button.setTitle("\(index)", for: .normal)
            if index == 1 {
                button.backgroundColor = Const.BtnColors.indicator
            }
            else {
                button.backgroundColor = Const.BtnColors.normal
            }
        }
        // reset overlap for check
        isOverlap = false
    }
    
    func getTimeStamp(format: String = "btn") -> String {
        /* https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
         */
        let formatter = DateFormatter()
        if format == "btn" {
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        } else {
            formatter.dateFormat = "yyyyMMddHHmmss"
        }
        return formatter.string(from: Date.now)
    }
    
    func createGameDoc() {
        //        let exerciseCollection = db.collection(Const.collectionName)
        let newGameDoc = Exercise(
            id: docId,
            repetition: repeNum,
            completed: false,
            startAt: gameStartAt,
            btnPressed: [String:Int]()
        )
        newGameDoc.createExerciseDoc()
    }
    
    func completeGame() {
        gameEndAt = getTimeStamp()
        Exercise.updateDocGameFinished(documentId: docId, isCompleted: true, endAt: gameEndAt)
        
        self.performSegue(withIdentifier: Const.gameToFinishedSegue, sender: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
        if segue.identifier == Const.gameToFinishedSegue
        {
            if let gameFinishedScreen = segue.destination as? GameDoneViewController
            {
                let gameInfor = Exercise(
                    isFreeMode: self.isFreeMode,
                    gameGoalType: self.goalType,
                    repetition: self.repeNum,
                    timeLimit: self.timeLimit,
                    completed: self.isCompleted,
                    roundsDone: self.roundDone,
                    timeTakenForRepe: self.timeTakenForRepe,
                    startAt: self.gameStartAt,
                    endAt: self.gameEndAt)
                gameFinishedScreen.gameFinishInfor = gameInfor
                gameFinishedScreen.isFreeMode = self.isFreeMode
                gameFinishedScreen.gameGoalType = self.goalType
                gameFinishedScreen.gameStartAt = self.gameStartAt
                gameFinishedScreen.gameEndAt = self.gameEndAt
                gameFinishedScreen.repeNumber = self.repeNum
                gameFinishedScreen.timeLimit = self.timeLimit
                gameFinishedScreen.timeTakenForRepe = self.timeTakenForRepe
                gameFinishedScreen.repeNumForTimeLimit = self.roundDone
            }
        }
    }
    
}
