
import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

enum registerError: Error {
    
    case incompleteForm
    case invalidName
    case invalidPassword
}

class RegisterViewController: UIViewController, UITextFieldDelegate {

    //This is a segue declaration
    let registerSegue = "registerSegue"
    //reference to database
    var ref = Database.database().reference()
    //interface
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBAction func registerButton(_ sender: UIButton) {
    
        //register method call
        do{
            try register()
            
        }catch registerError.incompleteForm{
            
            let alert = UIAlertController(title: "خطأ", message: "الرجاء تعبئة جميع الحقول", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch registerError.invalidName{
            
            let alert = UIAlertController(title:"خطأ", message: "تأكد من صحة الاسم" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch registerError.invalidPassword{
            
            let alert = UIAlertController(title:"خطأ", message: "يجب ان لا تقل كلمة المرور عن ٨ خانات" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch{
            
            let alert = UIAlertController(title:"خطأ", message: " " , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)

        }
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //interact with textfields
        usernameTextField.delegate=self
        emailTextField.delegate=self
        passTextField.delegate=self
        //back button
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
    }
    
    //register method
    func register() throws{
     
        //Assign values the user input (textfields)
        let email = emailTextField.text!
        let pass = passTextField.text!
        let name = usernameTextField.text!
        
        if(email.isEmpty || pass.isEmpty || name.isEmpty ){
            
            throw registerError.incompleteForm
        }
        
        if !name.isValidName{
            throw registerError.invalidName
        }
        
        if pass.count<8{
            
            throw registerError.invalidPassword
        }
        
        //Authintication for the email
        Auth.auth().createUser(withEmail: email , password: pass) {user, error in
            
            //parent ID
            guard let userID = user?.user.uid else {
                
                //if the users input is wrong an alert will show
                    let alert = UIAlertController(title:"خطأ", message: "تأكد من صحة البريد الالكتروني" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "موافق" , style: .default))
                    self.present(alert, animated: true, completion: nil)
               
                return
                
            }
            
            //if there is no errors
            if error == nil {
                
                //users values
                let dataArray = ["Email" : email, "Pass" : pass, "Name" : name]
                
                //insert the values into the database
                self.ref.child("Parent").child(userID).setValue(dataArray, withCompletionBlock: { (error, result) in
                    //if there are no errors
                    if error == nil {
                        
                        //the segue will be performed and move to the next interface
                        let alert = UIAlertController(title:"", message: "تم التسجيل بنجاح" , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { _ in
                            self.performSegue(withIdentifier: "registerSegue", sender: nil)

                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    //if there are errors
                    else {
                        //alert will show to inform you
                        let alert = UIAlertController(title:"خطأ", message: " " , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "موافق" , style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            
            }
          }
        }
    
    
    //keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField{
            emailTextField.becomeFirstResponder()
            
        }else if textField == emailTextField{
            passTextField.becomeFirstResponder()
            
        }else{
            view.endEditing(true)
       }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}
extension String{
    
    var isValidName: Bool{
        let nameFormat = "[A-Z0-9a-zأ-ي ا-ي._%+-]{2,10}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: self)
    }
}

    
