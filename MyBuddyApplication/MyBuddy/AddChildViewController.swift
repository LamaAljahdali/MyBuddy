
import UIKit
import Firebase
import FirebaseDatabase

enum addChildError: Error {
    case incompleteForm
    case invalidName
    case invalidAge
    case inSelected
}
class AddChildViewController: UIViewController, UITextFieldDelegate {

    var ref = Database.database().reference()
    
    @IBOutlet weak var addChildLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var girlProfilePhoto: UIImageView!
    @IBOutlet weak var boyProfilePhoto: UIImageView!
    @IBOutlet weak var boyProfile: UIButton!
    @IBAction func boyProf(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            girlProfile.isSelected = false
            
        }else{
            sender.isSelected = true
            girlProfile.isSelected = false
        }
    }
    
    @IBOutlet weak var girlProfile: UIButton!
    @IBAction func girlProf(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            boyProfile.isSelected = false
            
        }else{
            sender.isSelected = true
            boyProfile.isSelected = false
        }
    }
    @IBAction func addButton(_ sender: UIButton) {
        do{
          try checkForm()
        }catch addChildError.incompleteForm{
            let alert = UIAlertController(title: "خطأ", message: "الرجاء تعبئة جميع الحقول", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        } catch addChildError.invalidName{
            let alert = UIAlertController(title:"خطأ", message: "تأكد من صحة الاسم" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }catch addChildError.invalidAge{
            let alert = UIAlertController(title:"خطا", message: "عمر الطفل المسموح به ٤ الى ٩ سنوات" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: nil)
        }catch addChildError.inSelected{
            let alert = UIAlertController(title:"خطأ", message: "اختر جنس الطفل" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        catch {
            let alert = UIAlertController(title:"خطأ", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        nameTextField.delegate = self 
        ageTextField.delegate = self
        
        ref = Database.database().reference()

        Database.database().reference().child("Parent").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {

            }
        }
    }


    func checkForm()throws{
        let name = nameTextField.text!
        let age = ageTextField.text!
        if(name.isEmpty || age.isEmpty){ throw addChildError.incompleteForm}
        
        if(!age.isValidAge){ throw addChildError.invalidAge}
        
        if(!name.isValidName){throw addChildError.invalidName}
        
        if(boyProfile.isSelected==false && girlProfile.isSelected==false){
            throw addChildError.inSelected
        }
        guard let parentID = Auth.auth().currentUser?.uid else {return}
            var gender = ""
            if boyProfile.isSelected == true{
                gender = "Female"
                
            }else if girlProfile.isSelected == true{
                gender = "Male"
            }
        let dataArray : [String : Any] = ["name": name , "age": age , "score": 0 , "level" : 0 , "gender" : gender]
        ref.child("ChildProfile").child(parentID).childByAutoId().setValue(dataArray) { (error, result) in
                if error == nil {
                    let alert = UIAlertController(title:"", message: "تمت اضافة الطفل بنجاح" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "addChildSegue", sender: nil)
                     }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    //keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            ageTextField.becomeFirstResponder()
        }else {
            view.endEditing(true)
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }

}

extension String{
    
    var isValidAddChildName: Bool{
        let nameFormat = "[A-Z0-9a-zأ-ي ا-ي._%+-]{2,10}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: self)
    }
    
    var isValidAge: Bool{
        let ageFormat = "[4-9٤-٩]{1}"
        let agePredicate = NSPredicate(format: "SELF MATCHES %@", ageFormat)
        return agePredicate.evaluate(with: self)

    }
}

