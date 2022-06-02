import UIKit

class GameModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.freeModeToCustSegue
        {
            if let gameCustScreen = segue.destination as? GameCustomizeViewController
            {
                gameCustScreen.isFreeMode = true
            }
        }
    }
    

}
