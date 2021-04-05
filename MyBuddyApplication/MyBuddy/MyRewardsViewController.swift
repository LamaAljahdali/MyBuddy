
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MyRewardsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    var ref = Database.database().reference(withPath: "Rewards")
    var myRewards : [rewards]=[]
    
    @IBOutlet weak var rewardsListTableView: UITableView!
    @IBOutlet weak var myRewardsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        rewardsListTableView.delegate = self
        rewardsListTableView.dataSource = self
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        if let childID = ChildProfilesViewController.selectedChild{
        guard let key = childID.key else{return}
       
            ref.child(userID).child(key).observeSingleEvent(of: .value) { (snapshot) in

                if let value = snapshot.value as? [String : AnyObject] {
                
                for (index,child) in value.values.enumerated() {
                    
                  let  childID = Array(value.keys)[index]
                    
                    let rewardsName = child["RewardsName"] as? String
                    let rewardsType = child["RewardsType"] as? String

                    let child = rewards(key: childID,rewardsName: rewardsName , rewardsType: rewardsType )
                    
                    self.myRewards.append(child)
                    print(self.myRewards)
                    
                }
                
                self.rewardsListTableView.reloadData()
                
            }
        }}
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rewardsObject = myRewards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRewardsCell", for: indexPath) as! MyRewardsListTableViewCell
        cell.rewardsNameLabel.text = rewardsObject.rewardsName
        
        return cell
    }
    
    func tableView(_ rewardsListTableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)

        return UISwipeActionsConfiguration(actions: [delete])
        
   }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let deleteAction = UIContextualAction(style: .destructive, title: "حذف"){ (action, view, completion) in

            guard let ParentID = Auth.auth().currentUser?.uid else {return} // parent ID
            
            if let childID = ChildProfilesViewController.selectedChild?.key{
                if let rewardID = self.myRewards[indexPath.row].key{
                    self.ref.child(ParentID).child(childID).child(rewardID).removeValue { (error, referance) in
                        if error == nil {
                            self.myRewards.remove(at: indexPath.row)
                            self.rewardsListTableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
            
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

struct rewards{
    
    let key: String?
    let rewardsName: String?
    let rewardsType: String?
    
}
