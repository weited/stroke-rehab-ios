//
//  GamePlayViewController.swift
//  StrokeRehab
//
//  Created by mobiledev on 28/5/2022.
//

import UIKit

class GamePlayViewController: UIViewController {

    var repeNum : Int = 3
    var isFreeMode : Bool = false
    var isBtnRandom : Bool = true
    var isBtnIndicator : Bool = true
    var btnNum : Int = 3
    var btnSize : Int = 2
    
    var targetBtns : [Int] = [1,2,3]
    var randomBtns : [Int] = [2,1,3]

    var currentBtn : Int = 1
    var round : Int = 0
    
    @IBOutlet weak var btnAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        for index in 1...btnNum {
            btnAreaView.layoutIfNeeded()
            let height = btnAreaView!.frame.size.height
            let width = btnAreaView!.frame.size.width
            let button = UIButton(frame: CGRect(x: Int(CGFloat( arc4random_uniform( UInt32( floor( width  ) ) ) )), y: Int(CGFloat( arc4random_uniform( UInt32( floor( height ) ) ) )), width: 50, height: 50))
            button.backgroundColor = .green
            button.setTitle("\(randomBtns[index-1])", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.tag = index

            self.view.addSubview(button)
        }
        


        // Do any additional setup after loading the view.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.backgroundColor = .blue
        print("Button tapped\(sender.tag)")
        print("size is \(self.view!.frame.height)")
        print("size is \(self.view!.frame.width)")

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
