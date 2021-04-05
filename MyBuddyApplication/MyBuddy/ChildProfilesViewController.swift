

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChildProfilesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    static var selectedChild : Childs?
    var selectedData : String = ""
    var selectedRowNumber : Int = 0

    @IBOutlet weak var childsLabel: UILabel!
   
    @IBOutlet weak var profilesTableView: UITableView!
    
    let ref = Database.database().reference(withPath: "ChildProfile")
    var profiles: [Childs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilesTableView.delegate = self
        profilesTableView.dataSource = self
   
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profiles.removeAll()
        getChildsData()
    }
    
    func getChildsData() {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}

        ref.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
            if let value = snapshot.value as? [String : AnyObject] {
                
                
                for (index,child) in value.values.enumerated() {
                    
                    let childID = Array(value.keys)[index]
                    
                    let name = child["name"] as? String
                    let age = child["age"] as? Int
                    let level = child["level"] as? Int
                    let score = child["score"] as? Int
                    let gender = child["gender"] as? String

                    let child = Childs(key: childID, name: name, age: age, level: level, score: score , gender: gender)
                    
                    self.profiles.append(child)
                    
                }
                
                self.profilesTableView.reloadData()
                
            }
       
        }
    }
 
    
    func tableView(_ profilesTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return profiles.count 
    }
    
    func tableView(_ profilesTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profilesTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! profilesTableViewCell
        let childsObject = profiles[indexPath.row]
        
        cell.lblName.text = childsObject.name
        
            
        return cell
    }
   
    
    func tableView(_ profilesTableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteProfile(at: indexPath)
        let edit = editAction(at: indexPath)

        return UISwipeActionsConfiguration(actions: [delete, edit])
        
   }
    
    func deleteProfile(at indexPath: IndexPath) -> UIContextualAction{
        
        let deleteAction = UIContextualAction(style: .destructive, title: "حذف"){ (action, view, completion) in

            guard let ParentID = Auth.auth().currentUser?.uid else {return} // parent ID
            
            if let childID = self.profiles[indexPath.row].key {
                self.ref.child(ParentID).child(childID).removeValue { (error, referance) in
                    if error == nil {
                        self.profiles.remove(at: indexPath.row)
                        self.profilesTableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }

            }
            
            completion(true)
            
        }
        
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{

        let editAction = UIContextualAction(style: .normal, title: "تعديل"){(action, view, completion) in
            
            let child = self.profiles[indexPath.row]
            
            self.performSegue(withIdentifier: "editProfile", sender: child)
            
        }
        
        editAction.backgroundColor = .gray
        return editAction
    }
    
  func editProfile(newName: String) {
    
    profiles[selectedRowNumber].name = newName
    guard let ID = Auth.auth().currentUser?.uid else {return}
    if let childID = ChildProfilesViewController.selectedChild{
        guard let key = childID.key else{return}
        ref.child(ID).child(key).updateChildValues(["name": newName])
    }
    profilesTableView.reloadData()

  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "editProfile" {
            let destination = segue.destination as! editProfileViewController
            destination.child = sender as? Childs
        }
        
        
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ChildProfilesViewController.selectedChild = profiles[indexPath.row]
        
        if HomePageViewController.selectedPage == "childProfile" {
            performSegue(withIdentifier: HomePageViewController.selectedPage, sender: Childs.self)
        }
        else if HomePageViewController.selectedPage == "video" {
            performSegue(withIdentifier: HomePageViewController.selectedPage, sender: nil)
        }
        else if HomePageViewController.selectedPage == "rewards"{
            performSegue(withIdentifier: HomePageViewController.selectedPage, sender: nil)
        } else{
            
            performSegue(withIdentifier:"childProfile", sender: Childs.self)
        }
    }

}

struct Childs{
    
    let key: String?
    var name: String?
    let age : Int?
    let level: Int?
    let score: Int?
    let gender: String?
}
