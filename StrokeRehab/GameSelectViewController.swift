//
//  GameSelectViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit

class GameSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindFromGameDoneToHistory(sender: UIStoryboardSegue)
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

}
