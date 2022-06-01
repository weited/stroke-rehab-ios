//
//  HistoryDetailViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 31/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryDetailViewController: UIViewController {
    
    var exercise : Exercise?
    var exerciseIndex : Int?
    var btnPressedArry = [[String : String]]()
    var docId : String?
    
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalLimitLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var endAtLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPressedNumLabel: UILabel!
    @IBOutlet weak var repeDoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        if let displayExercise = exercise
        {
            docId = displayExercise.id
            btnPressedArry = displayExercise.btnPressed
            let totalPressedNum = displayExercise.btnPressed.count
            repeDoneLabel.text = String(displayExercise.repetitionDone)
            totalPressedNumLabel.text = String(totalPressedNum)
            goalTypeLabel.text = displayExercise.gameGoalType
            goalLimitLabel.text = "\(displayExercise.repetitionLimit)    Repetitions"
            
        }
        
        
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteRecord(sender)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
    }
    
    func deleteRecord(_ sender: Any) {
        if let id = docId {
            let db = Firestore.firestore()
            let document = db.collection(Const.collectionName).document(id)
            document.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //this code triggers the unwind segue manually
                    self.performSegue(withIdentifier: Const.deleteRecordSegue, sender: sender)
                    print("Document successfully removed!")
                }
            }
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

extension HistoryDetailViewController : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

extension HistoryDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return btnPressedArry.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Const.historyDetailCell, for: indexPath)
        
        // Configure the cell...
        //get the movie for this row
        let button = btnPressedArry[indexPath.row]
        
        
        //        if let btn = button.first {
        //            cell.textLabel?.text = btn.key
        let seqLabel = cell.viewWithTag(1) as? UILabel
        let timeLabel = cell.viewWithTag(2) as? UILabel
        let numPsdButton = cell.viewWithTag(3) as? UIButton
        seqLabel?.text = String(indexPath.row+1)
        timeLabel?.text = button["time"]
        numPsdButton?.setTitle("\(button["btn"]!)", for: .normal)
        if button["check"] == "true" {numPsdButton?.tintColor = .red}
        //            numPsdButton?.layer.cornerRadius = 36
        //        }
        
        //        if let time = button.keys.first {
        //            cell.textLabel?.text = time
        //            let label = cell.viewWithTag(1) as? UILabel
        //            label?.text = String(button.values.first)
        ////                    print("cell button \(button)")
        //        }
        
        
        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        //        if let btnCell = cell as? HistoryUITableViewCell
        //        {
        //            //populate the cell
        //            exerciseCell.repeLabel.text = String(exercise.repetition)
        //            exerciseCell.startAtLabel.text = String(exercise.startAt)
        //            exerciseCell.endAtLabel.text = exercise.endAt
        //        }
        return cell
    }
}
