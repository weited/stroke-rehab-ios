//
//  HistoryUIViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 31/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryUIViewController: UIViewController {

    var exercises = [Exercise]()
        
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        historyTableView.dataSource = self
        let db = Firestore.firestore()
        let exerciseCollection = db.collection(Const.collectionName)
        
        let atemp = Exercise(id:  nil, isFreeMode: false, gameGoalType: <#T##String#>, repetition: <#T##Int#>, timeLimit: <#T##Int#>, completed: <#T##Bool#>, roundsDone: <#T##Int#>, timeTakenForRepe: <#T##Int#>, startAt: <#T##String#>, endAt: <#T##String#>, btnPressed: <#T##[String : Int]#>, photoPath: <#T##String#>)
        
        exerciseCollection.getDocuments() { (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: Exercise.self)
                    }
                    switch conversionResult
                    {
                        case .success(let exercise):
                            print("Exercise: \(exercise)")
                                
                            //NOTE THE ADDITION OF THIS LINE
                            self.exercises.append(exercise)
                            
                        case .failure(let error):
                            // A `Movie` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding exercise: \(error)")
                    }
                }
                
                //NOTE THE ADDITION OF THIS LINE
                self.historyTableView.reloadData()
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

extension HistoryUIViewController : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

extension HistoryUIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HistoryUITableViewCell", for: indexPath)

        // Configure the cell...
        //get the movie for this row
        let exercise = exercises[indexPath.row]

        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        if let exerciseCell = cell as? HistoryUITableViewCell
        {
            //populate the cell
            exerciseCell.repeLabel.text = String(exercise.repetition)
            exerciseCell.startAtLabel.text = String(exercise.startAt)
            exerciseCell.endAtLabel.text = exercise.endAt
        }
        return cell
    }
}
