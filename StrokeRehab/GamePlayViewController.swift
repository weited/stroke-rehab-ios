import UIKit
import Firebase
import FirebaseFirestoreSwift

class GamePlayViewController: UIViewController {
    
    var isPrescribedGame : Bool = false
    var goalType : String = Const.GoalType.repetition.rawValue
    var repeNum : Int = 3
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 50
    var timeLimit : Int = 10
    var isCompleted : Bool = false
    
    var docId : String = ""
    var gameStartAt : String = ""
    var gameEndAt : String = ""
    var timeTakenForRepe : Int = 0
    
//    var targetBtns : [Int] = [1,2,3]
//    var randomBtns : [Int] = [2,1,3]
    
    var currentBtn : Int = 1
    var roundsDone : Int = 0
    
    var btnUIGroup : [UIButton] = []
    var secBtnUIGroup : [UIButton] = []
    var isOverlap : Bool = false
    
    var timer = Timer()
    var timeCuntDown : Int = 30
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var roundsDoneLabel: UILabel!
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        timeCuntDown = timeLimit
        print("game play \(goalType)")
        //        self.title = "New title"
        if isFreeMode == true {
            goalLabel.text = "Free Mode"
        } else {
            if goalType == Const.GoalType.repetition.rawValue {
                goalLabel.text = String(repeNum)
            } else {
                self.title = String(timeLimit)
                goalLabel.text = "\(timeLimit) S"
            }
            
        }
        
        
        gameStartAt = getTimeStamp()
        
//        timer.invalidate()
        
        self.docId = getTimeStamp(format: "gameId")
        
        // create an empty document
        createGameDoc()
        
//        if isPrescribedGame {
//            createBtnGroup()
//        } else {
//            btnUIGroup = createBtnGroup(isPscGame: false, isSecondGroup: false)
//            secBtnUIGroup = createBtnGroup(isPscGame: false, isSecondGroup: true)
//        }
        
        
        
      
        
        print("############### \(btnUIGroup.count)")
        
        func createBtnGroup() {
            let i = isPrescribedGame ? 1 : 2
            for index in 1...(btnNum * i) {
                btnAreaView.layoutIfNeeded()
                let height = btnAreaView!.frame.size.height - CGFloat(btnSize)
                let width = btnAreaView!.frame.size.width - CGFloat(btnSize)
                
                let eachHeight = height/CGFloat(btnNum)
                
                let button = UIButton()
                button.frame = CGRect(x: Int(width/2), y: Int(eachHeight) * index - Int(eachHeight)/2, width: btnSize, height: btnSize)
                button.layer.cornerRadius = CGFloat(btnSize/2)
                
                if isPrescribedGame == true {
                    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    button.addTarget(self, action: #selector(buttonDownAction), for: .touchDown)
                    button.addTarget(self, action: #selector(buttonReleaseAction), for: .touchUpOutside)
                } else {
                    button.addTarget(self, action: #selector(twoButtonDownAction), for: .touchDown)
                }
                
                button.tag = index
//                isSecondGroup ? (button.tag = index + 5) : (button.tag = index)

                btnAreaView.addSubview(button)
                btnUIGroup.append(button)
            }
        }
        


        resetBtn()
        // random button position first then check if overlap
        if isBtnRandom { reorderBtnPosition() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        print("stop timer")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        startTimer()
    }
    
    @IBAction func endGameBtnTapped(_ sender: Any) {
        timer.invalidate()
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to end?", preferredStyle: .alert)
        
        let end = UIAlertAction(title: "End", style: .destructive, handler: { (action) -> Void in
            self.finishGame(isCompleted: false)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.startTimer()
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(end)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    @objc func timerForRepetition() {
        timeTakenForRepe += 1
        self.title = String(timeTakenForRepe)
    }
    
    @objc func timerForTimeLimit() {
        timeCuntDown -= 1
        self.title = String(timeCuntDown)
        if timeCuntDown == 0 {
            timer.invalidate()
            finishGame(isCompleted: true)
        }
    }
    
    @objc func buttonDownAction(sender: UIButton!) {
        print("Touch Down Action \(sender.tag)")
        if sender.tag != currentBtn {
            sender.setTitle("X", for: .normal)
            sender.backgroundColor = Const.BtnColors.wrong
        }
    }
    
    @objc func buttonReleaseAction(sender: UIButton!) {
        print("ReleaseAction \(sender.tag)")
        if sender.tag == currentBtn-1 {
            sender.setTitle("✓", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        } else {
            sender.setTitle("\(sender.tag)", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped\(sender.tag)")
        var pressCheck = "false"
        
        if sender.tag == currentBtn {
            pressCheck = "true"
            sender.setTitle("✓", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
            if isBtnIndicator == true && currentBtn < btnNum {
                btnUIGroup[currentBtn].backgroundColor = Const.BtnColors.indicator
            }
            currentBtn += 1
            
            // Completed a round, Reset first btn, increase rounds
            if currentBtn > btnNum {
                currentBtn = 1
                roundsDone += 1
                roundsDoneLabel.text = String(roundsDone)
                
                if isFreeMode == false && goalType == Const.GoalType.repetition.rawValue && roundsDone == repeNum {
                    finishGame(isCompleted: true)
                    print("You finished!")
                    return
                }

                resetBtn()
                // random button position
                if isBtnRandom { reorderBtnPosition() }
            }
        } else {
            sender.setTitle("\(sender.tag)", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        }
        Exercise.addBtnPressedToDB(documentId: docId, repetitionDone: roundsDone, btnPressed: ["time" : getTimeStamp(), "btn":String(sender.tag),"check":pressCheck])
    }
    
    @objc func twoButtonDownAction(sender: UIButton!) {
        print("pressed!!!!!!!!!! \(sender.tag)")
    }
    
    func startTimer() {
        timer.invalidate()
        if goalType == Const.GoalType.repetition.rawValue {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForRepetition), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForTimeLimit), userInfo: nil, repeats: true)
        }
        
    }
    
    func resetBtn() {
        for index in 1...btnNum {
            //            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
//            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: btnSize, height: btnSize)
            button.setTitle("\(index)", for: .normal)
//            button.titleLabel?.font = UIFont(name: "System", size: btnsize/2)
            if index == 1 && isBtnIndicator == true {
                button.backgroundColor = Const.BtnColors.indicator
            }
            else {
                button.backgroundColor = Const.BtnColors.normal
            }
        }
    }
    
    func checkBtnOverlap(btnGroup: [UIButton]) -> Bool {
        //        for index in 1...btnNum {var button = btnAreaView.viewWithTag(index) as? UIButton}
        //        var isOverlap : Bool = false
        // reset overlap for check
        isOverlap = false
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
        return isOverlap
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
        let newGameDoc = Exercise(
            id: docId,
            isFreeMode: isFreeMode,
            gameGoalType: goalType,
            repetitionLimit: repeNum,
            completed: false,
            startAt: gameStartAt,
            btnPressed: [[String:String]]()
        )
        newGameDoc.createExerciseDoc()
    }
    
    func finishGame(isCompleted compeleteStatus : Bool = false) {
        gameEndAt = getTimeStamp()
        Exercise.updateDocGameFinished(documentId: docId, isCompleted: compeleteStatus, endAt: gameEndAt, repetitionsDone: roundsDone)
        timer.invalidate()
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
                    repetitionLimit: self.repeNum,
                    timeLimit: self.timeLimit,
                    completed: self.isCompleted,
                    repetitionDone: self.roundsDone,
                    timeTakenForRepe: self.timeTakenForRepe,
                    startAt: self.gameStartAt,
                    endAt: self.gameEndAt)
                gameFinishedScreen.gameFinishInfor = gameInfor
//                gameFinishedScreen.isFreeMode = self.isFreeMode
//                gameFinishedScreen.gameGoalType = self.goalType
//                gameFinishedScreen.gameStartAt = self.gameStartAt
//                gameFinishedScreen.gameEndAt = self.gameEndAt
//                gameFinishedScreen.repeNumber = self.repeNum
//                gameFinishedScreen.timeLimit = self.timeLimit
//                gameFinishedScreen.timeTakenForRepe = self.timeTakenForRepe
//                gameFinishedScreen.repeNumForTimeLimit = self.roundsDone
            }
        }
    }
    
}
