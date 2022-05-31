//
//  GamePlayViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 20/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class GamePlayViewController: UIViewController {
    
    var goalType : String = Const.GoalType.repetition.rawValue
    var repeNum : Int = 3
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 50
    var timeLimit : Int = 0
    var isCompleted : Bool = false
    
    var docId : String = ""
    var gameStartAt : String = ""
    var gameEndAt : String = ""
    var timeTakenForRepe : Int = 0
    
    var targetBtns : [Int] = [1,2,3]
    var randomBtns : [Int] = [2,1,3]
    
    var currentBtn : Int = 1
    var roundsDone : Int = 0
    
    var btnUIGroup : [UIButton] = []
    var isOverlap : Bool = false
    
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var roundsDoneLabel: UILabel!
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        //        self.title = "New title"
        goalLabel.text = isFreeMode ? "Free Mode" : String(repeNum)
        
        gameStartAt = getTimeStamp()
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForRepetition), userInfo: nil, repeats: true)
        
        self.docId = getTimeStamp(format: "gameId")
        print("###############: \(Exercise.GoalType.repetition)")
        
        // create an empty document
        createGameDoc()
        
        for index in 1...btnNum {
            btnAreaView.layoutIfNeeded()
            let height = btnAreaView!.frame.size.height - CGFloat(btnSize)
            let width = btnAreaView!.frame.size.width - CGFloat(btnSize)
            
            let eachHeight = height/CGFloat(btnNum)
            print("size is \(height)")
            print("size is \(width)")
            //            let button = UIButton(frame: CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50))
            
            let button = UIButton()
            button.frame = CGRect(x: Int(width/2), y: Int(eachHeight) * index - Int(eachHeight)/2, width: btnSize, height: btnSize)
            button.layer.cornerRadius = CGFloat(btnSize/2)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonDownAction), for: .touchDown)
            button.addTarget(self, action: #selector(buttonReleaseAction), for: .touchUpInside)
            button.tag = index
            btnAreaView.addSubview(button)
            btnUIGroup.append(button)
        }

        resetBtn()
        // random button position first then check if overlap
        if isBtnRandom {
            reorderBtnPosition()
        }
       
//        repeat
//        {
//            randomPosition()
//            checkBtnOverlap(btnGroup: btnUIGroup)
//        }
//        while isOverlap == true
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
            if isBtnIndicator == true && currentBtn < btnNum {
                btnUIGroup[currentBtn].backgroundColor = Const.BtnColors.indicator
//                btnUIGroup[currentBtn].layer.borderColor = .init(gray: 2, alpha: 1)
            }
            currentBtn += 1
            
            // Completed a round, Reset first btn, increase rounds
            if currentBtn > btnNum {
                currentBtn = 1
                roundsDone += 1
                roundsDoneLabel.text = String(roundsDone)
                
                // Finish Game and Nav to next UI
                if roundsDone == repeNum {
                    completeGame()
                    print("You finished!")
                    return
                }
                
                resetBtn()
                // random button position
                if isBtnRandom { reorderBtnPosition() }
            }
        }
    }
    
    func resetBtn() {
        for index in 1...btnNum {
            //            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
//            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: btnSize, height: btnSize)
            button.setTitle("\(index)", for: .normal)
            if index == 1 && isBtnIndicator == true {
                button.backgroundColor = Const.BtnColors.indicator
            }
            else {
                button.backgroundColor = Const.BtnColors.normal
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
        let height = btnAreaView!.frame.size.height - CGFloat(btnSize)
        let width = btnAreaView!.frame.size.width - CGFloat(btnSize)
        
        for index in 1...btnNum {
            //            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: btnSize, height: btnSize)
//            button.setTitle("\(index)", for: .normal)
//            if index == 1 && isBtnIndicator == true {
//                button.backgroundColor = Const.BtnColors.indicator
//            }
//            else {
//                button.backgroundColor = Const.BtnColors.normal
//            }
        }
        // reset overlap for check
        isOverlap = false
    }
    
    func reorderBtnPosition() {
        repeat
        {
            randomPosition()
            checkBtnOverlap(btnGroup: btnUIGroup)
        }
        while isOverlap == true
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
                    roundsDone: self.roundsDone,
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
                gameFinishedScreen.repeNumForTimeLimit = self.roundsDone
            }
        }
    }
    
}
