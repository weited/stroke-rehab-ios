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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.dGameToCustSegue
        {
            if let gameCustScreen = segue.destination as? GameCustomizeViewController
            {
                gameCustScreen.isFreeMode = true
                gameCustScreen.isPrescribedGame = false
            }
        }
    }
}
