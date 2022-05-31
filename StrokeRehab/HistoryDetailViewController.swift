//
//  HistoryDetailViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 31/5/2022.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    var exercise : Exercise?
    var exerciseIndex : Int?
    
    @IBOutlet weak var totalPressedNumLabel: UILabel!
    @IBOutlet weak var repeDoneLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let displayExercise = exercise
        {
            let totalPressedNum = displayExercise.btnPressed.count
            repeDoneLabel.text = String(displayExercise.repetition)
            totalPressedNumLabel.text = String(totalPressedNum)
        }
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
