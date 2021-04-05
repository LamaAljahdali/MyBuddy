
import UIKit
import Firebase
import FirebaseAuth
import AVKit

class VRVidViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    var behaviorsArray: [behaviors] = []

    @IBOutlet weak var behaviorsLabel: UILabel!
   
    @IBOutlet weak var behaviorsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        behaviorsTableView.delegate = self
        behaviorsTableView.dataSource = self
                
        let ref = Database.database().reference().child("Behaviors").child((ChildProfilesViewController.selectedChild?.key)!)
        
        ref.observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? String  {
                print(value)
                let video = behaviors(behaviorName: value)
                self.behaviorsArray.append(video)
                self.behaviorsTableView.reloadData()
            }
        }
        
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        
       print("video ended")
       self.updateScore()

    }
    
    func updateScore(){
        
        let ref = Database.database().reference(withPath: "ChildProfile")
        guard let ID = Auth.auth().currentUser?.uid else {return}
        if let childID = ChildProfilesViewController.selectedChild{
            guard let key = childID.key else{return}
            guard let score = childID.score else{return}
            let updateScore = score + 2
            ref.child(ID).child(key).updateChildValues(["score": updateScore])
            updateLevel()
        }
    }
    
    
    
    func updateLevel() {
        
        let ref = Database.database().reference(withPath: "ChildProfile")
        guard let ID = Auth.auth().currentUser?.uid else {return}
        if let childID = ChildProfilesViewController.selectedChild{
            guard let key = childID.key else{return}
            guard let score = childID.score else {return}
            guard let level = childID.level else {return}
            let newScore = Int(score)
            let newLevel = Int(level)
            if(newScore % 2 == 0){
                let updateLevel = newLevel + 1
                ref.child(ID).child(key).updateChildValues(["level": updateLevel])
                
            }
        }
    }
    
    private func playVideo(index : Int) {
        guard let path = Bundle.main.path(forResource: behaviorsArray[index].behaviorName, ofType:"mp4") else {
                debugPrint("video not found")
                return
            }
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidEnd), name:
                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return behaviorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorsCell") as! behaviorsTableViewCell
        
        let behaviorssObject = behaviorsArray[indexPath.row]
        
        cell.behNameLbl.text = behaviorssObject.behaviorName
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(index : indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }    
    
}

struct behaviors{
    
    let behaviorName: String?
   
}

