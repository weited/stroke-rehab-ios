import UIKit

class GameCustomizeViewController: UIViewController {

    var isPrescribedGame : Bool = true
    var goalType : String = Const.GoalType.repetition.rawValue
    var repeNum : Int = 3
    var timeLimit : Int = 30
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 60
    
    let btnNumRange = ["2","3","4","5"]
    
    @IBOutlet weak var btnRandomSwitch: UISwitch!
    @IBOutlet weak var btnIndicatorSwitch: UISwitch!
    @IBOutlet weak var btnNumPicker: UIPickerView!
    @IBOutlet weak var btnSizeSlider: UISlider!
    @IBOutlet weak var demoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        btnNumPicker.dataSource = self
        btnNumPicker.delegate = self
        btnNumPicker.selectRow(1, inComponent: 0, animated: false)
        
        demoBtn.layer.cornerRadius = CGFloat(btnSize/2)
        demoBtn.clipsToBounds = true
        demoBtn.frame = CGRect(x: 180, y: 480, width: btnSize, height: btnSize)
        
        if isPrescribedGame == false {
            title = "Game Two Customization"
            btnRandomSwitch.isUserInteractionEnabled = false
            btnNumPicker.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func toggleBtnRandom(_ sender: Any) {
        isBtnRandom = btnRandomSwitch.isOn
    }
    
    @IBAction func toggleBtnIndicator(_ sender: Any) {
        isBtnIndicator = btnIndicatorSwitch.isOn
    }
    
    @IBAction func btnSizeSliderchanged(_ sender: Any) {
        btnSize = Int(btnSizeSlider.value)
        demoBtn.bounds.size.height = CGFloat(btnSize)
        demoBtn.bounds.size.width = CGFloat(btnSize)
        demoBtn.layer.cornerRadius = CGFloat(btnSize/2)
        print(btnSize)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.prescribedCustmToStartSegue
        {
            if let gamePlayScreen = segue.destination as? GamePlayViewController
            {
                gamePlayScreen.isPrescribedGame = isPrescribedGame
                gamePlayScreen.goalType = goalType
                gamePlayScreen.repeNum = repeNum
                gamePlayScreen.timeLimit = timeLimit
                gamePlayScreen.isFreeMode = isFreeMode
                gamePlayScreen.isBtnRandom = isBtnRandom
                gamePlayScreen.isBtnIndicator = isBtnIndicator
                gamePlayScreen.btnNum = btnNum
                gamePlayScreen.btnSize = btnSize
            }
        }
    }
}

extension GameCustomizeViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return btnNumRange.count
    }
}

extension GameCustomizeViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return btnNumRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnNum = Int(btnNumRange[row]) ?? 3
    }
}
