

import UIKit
import Foundation
import Firebase
import FirebaseAuth

enum loginError: Error {
    case incompleteForm
    case inSelectedUser
}

class SignInViewController: UIViewController, UITextFieldDelegate {

    //segue declaration
    let loginSegue = "loginSegue"

    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passSigninTextField: UITextField!
    @IBOutlet weak var parentBtn: UIButton!
    @IBAction func parentButton(_ sender: UIButton) {
     
        if sender.isSelected{
            sender.isSelected = false
            childBtn.isSelected = false
            
        }else{
            sender.isSelected = true
            childBtn.isSelected = false
        }
    }
    @IBOutlet weak var childBtn: UIButton!
    @IBAction func childButton(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            parentBtn.isSelected = false
            
        }else{
            sender.isSelected = true
            parentBtn.isSelected = false
        }
    }
    @IBAction func signinButton(_ sender: UIButton){
    
       do{
            try checkForm()
            
        }catch loginError.incompleteForm{
            
            let alert = UIAlertController(title: "خطأ", message: "الرجاء تعبئة جميع الحقول", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            return
            
        }catch loginError.inSelectedUser{
            
            let alert = UIAlertController(title: "خطأ", message: "اختر نوع المستخدم", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }catch {
            
            let alert = UIAlertController(title:"تسجيل دخول خاطئ", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "موافق" , style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passSigninTextField.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
    }
    
    func checkForm()throws{
      let email = emailTextField.text!
      let pass = passSigninTextField.text!
        
        if(email.isEmpty || pass.isEmpty){
            throw loginError.incompleteForm
        }
        if(parentBtn.isSelected==false && childBtn.isSelected==false){
            throw loginError.inSelectedUser
        }
        Auth.auth().signIn(withEmail: email , password: pass) {user, error in
            
            if error == nil {
                
                if (self.parentBtn.isSelected == true){
                    
                    self.performSegue(withIdentifier: "parentSegue" , sender: nil)
                    
                } else if(self.childBtn.isSelected ==  true){
                    
                    self.performSegue(withIdentifier: "childSegue", sender: nil)
                    
                }
            } else {
                let alert = UIAlertController(title:"تسجيل خاطئ", message: "  تأكد من صحة البيانات" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "موافق" , style: .default))
                self.present(alert, animated: true, completion: nil)
            }
    }
    }
    
   
    //keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            
            passSigninTextField.becomeFirstResponder()
            
        }else{
            view.endEditing(true)
        }
        
        return true
    }
    
    //keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}
