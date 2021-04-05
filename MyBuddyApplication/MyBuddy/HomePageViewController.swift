
import UIKit
import FirebaseAuth

class HomePageViewController: UIViewController {
    
    static var selectedPage = ""

    @IBAction func homeSignOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title:"تسجيل الخروج", message: "تأكيد تسجيل الخروج", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق" , style: .default , handler: {(action: UIAlertAction!)in self.performSegue(withIdentifier: "homeSignOut", sender: nil)
            }))
        
        alert.addAction(UIAlertAction(title: "الغاء" , style: .default))
        self.present(alert, animated: true, completion: nil)

    }
    @IBOutlet weak var mainMenuLabel: UILabel!
    @IBAction func childProfilesButton(_ sender: Any) {
        HomePageViewController.selectedPage = "childProfile"
    }
    @IBAction func addChildButton(_ sender: Any) {
    }
    @IBAction func VRVideosButton(_ sender: Any) {
        HomePageViewController.selectedPage = "video"
    }
    @IBAction func rewardsButton(_ sender: Any) {
        HomePageViewController.selectedPage = "rewards"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //disable back button
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
    }
    
}
