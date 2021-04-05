
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChildViewController: UIViewController {

    var ref: DatabaseReference!
   
    @IBAction func childSignOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title:"تسجيل الخروج", message: "تأكيد تسجيل الخروج", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق" , style: .default , handler: {(action: UIAlertAction!)in self.performSegue(withIdentifier: "childSignOut", sender: nil)
            }))
        
        alert.addAction(UIAlertAction(title: "الغاء" , style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numLevel: UILabel!
    @IBOutlet weak var numScore: UILabel!
    @IBOutlet weak var childAge: UILabel!
    @IBAction func listBehaviorsButton(_ sender: Any) {
    }
   
    @IBAction func rewardsButton(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
       if let child = ChildProfilesViewController.selectedChild {

            username.text = child.name
            print(child.age)
            childAge.text = String(child.age!)
            numLevel.text = String(child.level!)
            numScore.text = String(child.score!)
          
        
        var gender = child.gender
        
        if gender == "Female" {
            
            profileImg.image = UIImage(named: "girl")
            
        }else if gender == "Male"{
            
            profileImg.image = UIImage(named: "boy")
            
            
          }
        }
    }
    
    func showAlert(){
       
        let alert = UIAlertController(title: "تسجيل الخروج", message: "هل تريد تسجيل الخروج؟", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "الغاء", style: .destructive, handler: nil))
      
        present(alert, animated: true)
    }
    
    
}
