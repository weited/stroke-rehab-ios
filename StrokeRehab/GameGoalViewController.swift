import UIKit

class GameGoalViewController: UIViewController {
    
    
    var goalPickerRange : [String] = [String]()
    var goalType = Const.GoalType.repetition.rawValue
    var timeLimit : Int = 60
    var repNum : Int = 3
    let repRange = ["1","2","3","4","5","6","7","8","9","10"]
    let timeRange = [
        "30 s",
        "1 min",
        "1 min 30 s",
        "2 min",
        "2 min 30 s",
        "3 min",
        "3 min 30 s",
        "4 min",
        "4 min 30 s",
        "5 min 30 s",
        "5 min"
    ]
    
    @IBOutlet weak var repeButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var goalDisplayLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var goalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        goalPickerRange = repRange
        goalPicker.dataSource = self
        goalPicker.delegate = self
        goalPicker.selectRow(2, inComponent: 0, animated: false)
        
        timeButton.backgroundColor = UIColor.darkGray
        repeButton.backgroundColor = UIColor.systemBlue
        timeButton.layer.cornerRadius = 10
        repeButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func repeBtnTapped(_ sender: UIButton) {
        goalType = Const.GoalType.repetition.rawValue
        goalPickerRange = repRange
        goalPicker.reloadAllComponents()
        goalPicker.selectRow(2, inComponent: 0, animated: false)
        goalDisplayLabel.text = "3"
        timeButton.backgroundColor = UIColor.darkGray
        repeButton.backgroundColor = UIColor.systemBlue
//        timeButton.tintColor = UIColor.darkGray
    }
    
    
    @IBAction func timeBtnTapped(_ sender: UIButton) {
        goalType = Const.GoalType.timeLimit.rawValue
        goalPickerRange = timeRange
        goalPicker.reloadAllComponents()
        goalPicker.selectRow(1, inComponent: 0, animated: false)
        goalDisplayLabel.text = timeRange[1]
//        repeButton.tintColor = UIColor.darkGray
//        timeButton.tintColor = UIColor.systemBlue
        timeButton.backgroundColor = UIColor.systemBlue
        repeButton.backgroundColor = UIColor.darkGray
//        repeButton.tintColor = UIColor.darkGray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Const.goalToCustSegue
        {
            if let customizeUI = segue.destination as? GameCustomizeViewController
            {
                customizeUI.repeNum = self.repNum
                customizeUI.goalType = self.goalType
                customizeUI.timeLimit = self.timeLimit

            //https://stackoverflow.com/questions/35427102/hide-show-tab-bar-when-push-back-swift
//            self.hidesBottomBarWhenPushed = true
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension GameGoalViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return goalPickerRange.count
    }
}

extension GameGoalViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return goalPickerRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if goalType == Const.GoalType.repetition.rawValue {
            goalDisplayLabel.text = goalPickerRange[row]
            repNum = (row + 1)
            print("you selected \(row+1)")
        } else {
            goalDisplayLabel.text = goalPickerRange[row]
            timeLimit = (row + 1) * 30
            print("you selected \(timeLimit)")

        }

    }
}
