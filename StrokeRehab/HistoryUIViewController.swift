import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryUIViewController: UIViewController {

    var exercises = [Exercise]()
    var numOfExercises : Int = 0
    var totalPressed : Int = 0
    
    @IBOutlet weak var totalAtmptLabel: UIButton!
    @IBOutlet weak var totalBtnLabel: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        historyTableView.dataSource = self

        fetchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchHistory()
    }
        
    func fetchHistory() {
        let db = Firestore.firestore()
        let exerciseCollection = db.collection(Const.collectionName)
        exerciseCollection.getDocuments() { (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.exercises.removeAll()
                self.totalPressed = 0
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: Exercise.self)
                    }
                    switch conversionResult
                    {
                        case .success(let exercise):
                            //NOTE THE ADDITION OF THIS LINE
                            self.exercises.append(exercise)
                            
                        case .failure(let error):
                            // A `Movie` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding exercise: \(error)")
                    }
                }
                self.afterFetch()
                //NOTE THE ADDITION OF THIS LINE
                self.historyTableView.reloadData()
            }
        }
    }
    
    func afterFetch() {
        self.numOfExercises = self.exercises.count
        for btn in exercises {
            totalPressed += btn.btnPressed.count
        }
        
        totalAtmptLabel.setTitle("\(numOfExercises)", for: .normal)
        totalBtnLabel.setTitle("\(totalPressed)", for: .normal)
    }
    
    @IBAction func unwindToHistoryList(sender: UIStoryboardSegue)
    {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == Const.showHistoryDetailSegue
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? HistoryDetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedExerciseCell = sender as? HistoryUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
            guard let indexPath = historyTableView.indexPath(for: selectedExerciseCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedExercise = exercises[indexPath.row]

              //send it to the details screen
              detailViewController.exercise = selectedExercise
              detailViewController.exerciseIndex = indexPath.row
        }
    }
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
            exerciseCell.repeLabel.text = String(exercise.repetitionDone)
            exerciseCell.startAtLabel.text = String(exercise.startAt)
            exerciseCell.endAtLabel.text = exercise.endAt.isEmpty ? "Uncompleted game" : exercise.endAt
        }
        return cell
    }
}
