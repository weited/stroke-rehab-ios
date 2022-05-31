//
//  HistoryUIViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 31/5/2022.
//

import UIKit

class HistoryUIViewController: UIViewController {

    var exercises = {FS}
    @IBOutlet weak var repeNumLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var endAtLabel: UILabel!
    
    @IBOutlet weak var HistoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
