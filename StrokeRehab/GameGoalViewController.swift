//
//  GameGoalViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 26/5/2022.
//

import UIKit

class GameGoalViewController: UIViewController {
    
    @IBOutlet weak var repePicker: UIPickerView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    

    var repNum : Int = 3
    let repRange = ["2","3","4","5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repePicker.dataSource = self
        repePicker.delegate = self
        
        repePicker.selectRow(1, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let customizeUI = segue.destination as? GameCustomizeViewController
        {
            customizeUI.repeNum = repNum
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
        return repRange.count
    }
    
    
    
}

extension GameGoalViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelTitle.text = repRange[row]
        repNum = Int(repRange[row]) ?? 3
        print("you selected \(repRange[row])")
    }
    
}
