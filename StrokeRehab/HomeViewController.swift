//
//  HomeViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 7/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    let defalutFile = UserDefaults.standard
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        nameLabel.text = defalutFile.string(forKey: "username")?.isEmpty? defalutFile.string(forKey: "username") : "Explorer"
    }
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue)
    {
        if let nameChangeScreen = sender.source as? NameChangeViewController
        {
            nameLabel.text = defalutFile.string(forKey: "username")
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
