
import UIKit
import Firebase
import FirebaseDatabase

enum editError: Error {
    case invalidName
}

class editProfileViewController: UIViewController {

    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var editName: UITextField!
    
    var child : Childs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        if let childName = child?.name {
            editName.text = childName
        }
    }
    
    @IBAction func editProfileButton(_ sender: Any) {
        
        do{
           try editProfile()
            
        }catch editError.invalidName{
            
            let alert = UIAlertController(title:"خطأ", message: "تأكد من صحة الاسم" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch{
            let alert = UIAlertController(title:"خطأ", message: " " , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editProfile()throws{
        
        let newChildName = editName.text!
         
            if !newChildName.isValidName{
                throw editError.invalidName
            }
        
        let ref = Database.database().reference(withPath: "ChildProfile")
        guard let parentID = Auth.auth().currentUser?.uid else {return}
        guard let childID = child?.key else {return}
        ref.child(parentID).child(childID).child("name").setValue(newChildName) { (error, referance) in
            if error == nil {
                let alert = UIAlertController(title:"", message: "تم تعديل الاسم بنجاح" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
    //keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editName {
            view.endEditing(true)
        }
        return true
    }
    //keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
}
extension String{
    
    var isValidEditedName: Bool{
        let nameFormat = "[A-Z0-9a-zأ-ي ا-ي._%+-]{2,10}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: self)
    }
}
