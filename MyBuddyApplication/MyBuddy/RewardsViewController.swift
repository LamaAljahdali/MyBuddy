
import UIKit
import Firebase
import FirebaseDatabase

enum rewardsError: Error {
    case incompleteForm
    case invalidRewardsName
}

class RewardsViewController: UIViewController, UITextFieldDelegate{

    var ref = Database.database().reference()
    var list : [rewardsList] = []

    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    @IBAction func addRewardButton(_ sender: UIButton) {
  
        do{
         try addReward()
            
        } catch rewardsError.incompleteForm{
            let alert = UIAlertController(title:"خطا", message: "لم تقم باختيار الجائزة" , preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "موافق" , style: .default))
             self.present(alert, animated: true, completion: nil)
            
        } catch rewardsError.invalidRewardsName{
            let alert = UIAlertController(title:"تسجيل خاطئ", message: "تأكد من صحة الاسم" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch{
            let alert = UIAlertController(title:"خطأ", message: " " , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }
     }//button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        otherTextField.delegate = self
        ref = Database.database().reference()

   }
    
    func addReward() throws{
        
        let rewardsName = otherTextField.text!
        if(rewardsName.isEmpty){
            throw rewardsError.incompleteForm
        }
        if(!rewardsName.isValidRewardsName){
            throw rewardsError.invalidRewardsName
        }
        guard let parentID = Auth.auth().currentUser?.uid else{return}
        let dataArray: [String: Any] = ["RewardsName": rewardsName , "RewardsType": "Others"]
        if let childID = ChildProfilesViewController.selectedChild{
        guard let key = childID.key else {return}
        ref.child("Rewards").child(parentID).child(key).childByAutoId().setValue(dataArray){ (error, Result) in
        if error == nil{
                let alert = UIAlertController(title:"", message: "تمت اضافة الجائزة بنجاح" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "addRewardSegue", sender: nil)

            }))
            self.present(alert, animated: true, completion: nil)
            }
    }
}

    }
    
    //keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == otherTextField {
            view.endEditing(true)
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

struct rewardsList{
    var rewardsName: String?
    var rewardsType: String?
}

extension String{
    
    var isValidRewardsName: Bool{
        let nameFormat = "[A-Z0-9a-zأ-ي ا-ي._%+-]{2,10}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: self)
    }
}

