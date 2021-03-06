import UIKit
import Firebase
import FirebaseFirestoreSwift

class GamePlayViewController: UIViewController {
    
    var isPrescribedGame : Bool = true
    var goalType : String = Const.GoalType.repetition.rawValue
    var repeNum : Int = 3
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 2
    var btnSize : Int = 50
    var timeLimit : Int = 30
    var isCompleted : Bool = false
    
    var docId : String = ""
    var gameStartAt : String = ""
    var gameEndAt : String = ""
    var timeTakenForRepe : Int = 0
    
    var currentBtn : Int = 1
    var roundsDone : Int = 0
    
    var btnUIGroup : [UIButton] = []
    var doubleBtn : Int = 1
    var isOverlap : Bool = false
    
    var pressedBtn : [Int] = []
    var timer = Timer()
    var timeCuntDown : Int = 30
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var roundsDoneLabel: UILabel!
    @IBOutlet weak var gameDescLabel: UILabel!
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        timeCuntDown = timeLimit
        doubleBtn = isPrescribedGame ? 1 : 2
        self.docId = getTimeStamp(format: "gameId")
        gameStartAt = getTimeStamp()
        
        gameDescLabel.text = isPrescribedGame ? "(Tap button in order)" : "(Tap two buttons with same number)"
        
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

        // create an empty document
        createGameDoc()
        //create button group
        createBtnGroup()
        resetBtn()
        // random button position first then check if overlap
        if isBtnRandom { reorderBtnPosition() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        print("stop timer")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("did appear")
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
        }
        
        dialogMessage.addAction(end)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Timer
    
    func startTimer() {
        timer.invalidate()
        if goalType == Const.GoalType.repetition.rawValue {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForRepetition), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForTimeLimit), userInfo: nil, repeats: true)
        }
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
    
    // MARK: - Game One Button Action
    @objc func buttonDownAction(sender: UIButton!) {
//        print("Touch Down Action \(sender.tag)")
        if sender.tag != currentBtn {
            sender.setTitle("X", for: .normal)
//            colorBtn(btnTag: sender.tag, colorType: "wrong")
            sender.backgroundColor = Const.BtnColors.wrong
        } else {
            sender.backgroundColor = Const.BtnColors.pressedIndicator
        }
    }
    
    @objc func buttonReleaseAction(sender: UIButton!) {
//        print("ReleaseAction \(sender.tag)")
        if sender.tag == currentBtn-1 {
            sender.setTitle("???", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        } else if sender.tag == currentBtn {
            sender.backgroundColor = Const.BtnColors.indicator
        } else {
            sender.setTitle("\(sender.tag)", for: .normal)
            sender.backgroundColor = Const.BtnColors.normal
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        var pressCheck = "false"
        if sender.tag == currentBtn {
            pressCheck = "true"
            sender.setTitle("???", for: .normal)
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
    
    // MARK: - Game Two Button Action
    @objc func twoButtonDownAction(sender: UIButton!) {
        var pressCheck = "false"
//        pressedBtn.append(sender.tag)
        print("current btn number is : \(currentBtn)")
        if sender.tag % btnNum == currentBtn % btnNum {
            sender.backgroundColor = Const.BtnColors.pressedIndicator
        } else {
            sender.backgroundColor = Const.BtnColors.pressedNomal
        }
        // if no button in the array, means this is the first time pressed
        if pressedBtn.isEmpty {
            pressedBtn.append(sender.tag)
            if sender.tag % btnNum == currentBtn % btnNum { pressCheck = "true" }
        } else {
            // this is second pressed button, check two pressed btn equals current button
            pressedBtn.append(sender.tag)
            if (currentBtn % btnNum, sender.tag % btnNum) == (sender.tag % btnNum, pressedBtn.first! % btnNum) {
                pressCheck = "true"
                sender.setTitle("???", for: .normal)
                btnUIGroup[pressedBtn.first! - 1].setTitle("???", for: .normal)
                colorBtn(btnTag: sender.tag, colorType: "normal")
                colorBtn(btnTag: pressedBtn.first!, colorType: "normal")
                
                //set next btn indication
                if isBtnIndicator == true && currentBtn < btnNum {
                    colorBtn(btnTag: sender.tag + 1, colorType: "indicator")
                    colorBtn(btnTag: pressedBtn.first! + 1, colorType: "indicator")
                }
                currentBtn += 1
                
                // Completed a round, Reset first btn, increase rounds
                if currentBtn > btnNum {
                    currentBtn = 1
                    roundsDone += 1
                    roundsDoneLabel.text = String(roundsDone)
                    
                    resetBtn()
                    // random button position
                    if isBtnRandom { reorderBtnPosition() }
                }
            }
        }
        
//        print("now button has \(pressedBtn)")
        // save pressed button to DB
        var btnTitle : String
        if sender.tag > btnNum {
            btnTitle = String(sender.tag - btnNum)
        } else {
            btnTitle = String(sender.tag)
        }
        Exercise.addBtnPressedToDB(documentId: docId, repetitionDone: roundsDone, btnPressed: ["time" : getTimeStamp(), "btn": btnTitle, "check": pressCheck])
    }
    
    @objc func twoBtnReleaseAction(sender: UIButton!) {
        if !pressedBtn.isEmpty {pressedBtn.removeLast()}
        if sender.tag % btnNum == currentBtn {
            colorBtn(btnTag: sender.tag, colorType: "indicator")
        } else {
            colorBtn(btnTag: sender.tag, colorType: "normal")
        }
    }
    
//    @objc func twoBtnUpOutsideAction(sender: UIButton!) {
//        if !pressedBtn.isEmpty {pressedBtn.removeLast()}
//        if sender.tag % btnNum == currentBtn {
//            colorBtn(btnTag: sender.tag, colorType: "indicator")
//        } else {
//            colorBtn(btnTag: sender.tag, colorType: "normal")
//        }
//    }
    
    // MARK: Buttons
    func createBtnGroup() {
//            let i = isPrescribedGame ? 1 : 2
        for index in 1...(btnNum * doubleBtn) {
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
                button.addTarget(self, action: #selector(twoBtnReleaseAction), for: .touchUpInside)
                button.addTarget(self, action: #selector(twoBtnReleaseAction), for: .touchUpOutside)
                button.addTarget(self, action: #selector(twoBtnReleaseAction), for: .touchDragExit)
            }
            
            button.tag = index
//                isSecondGroup ? (button.tag = index + 5) : (button.tag = index)

            btnAreaView.addSubview(button)
            btnUIGroup.append(button)
        }
    }
    
    func resetBtn() {
        for index in 1...(btnNum * doubleBtn) {
            //            let button = btnAreaView.viewWithTag(index) as? UIButton
            let button = btnUIGroup[index-1]
//            button.frame = CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: btnSize, height: btnSize)
            button.setTitle("\(index>btnNum ? (index - btnNum) : index)", for: .normal)
//            button.titleLabel?.font = UIFont(name: "System", size: btnsize/2)
            if index % btnNum == 1 && isBtnIndicator == true {
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
        for i in 0..<(btnNum * doubleBtn) {
            if isOverlap == true {
                break
            } else {
                for j in i+1..<(btnNum * doubleBtn) {
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
        
        for index in 1...(btnNum * doubleBtn) {
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
    
    func colorBtn(btnTag : Int, colorType: String) {
        let btnIndex = btnTag - 1
        switch colorType {
        case "normal":
            btnUIGroup[btnIndex].backgroundColor = Const.BtnColors.normal
        case "wrong":
            btnUIGroup[btnIndex].backgroundColor = Const.BtnColors.wrong
        case "indicator":
            btnUIGroup[btnIndex].backgroundColor = Const.BtnColors.indicator
        default:
            btnUIGroup[btnIndex].backgroundColor = Const.BtnColors.normal
        }
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

     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
