
import UIKit
import Firebase
import AVKit
import AVFoundation

class CreateListOfBehaviorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var videosLabel: UILabel!
    
    @IBOutlet weak var listOfbehVidTableView: UITableView!
    
    let ref = Database.database().reference(withPath: "Videos")
    var videosArray: [Videos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "رجوع", style: .plain, target: nil, action: nil)
        listOfbehVidTableView.delegate = self
        listOfbehVidTableView.dataSource = self
                
        ref.observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String :AnyObject] {
                let video = Videos(key: snapshot.key, vidName: value["Videos Name"] as? String)
                self.videosArray.append(video)
                self.listOfbehVidTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return videosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videosCell") as! VideosTableViewCell
        
        let videosObject = videosArray[indexPath.row]

        cell.lblBehName.text = videosObject.vidName

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selectedChild
        let alert = UIAlertController(title: "تنبيه", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "مشاهدة", style: .default, handler: { action in
           // show video
            self.playVideo(index: indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "إضافة", style: .default, handler: { action in
            self.addVideo(indexPath: indexPath)
            
        }))
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func playVideo(index : Int) {
        guard let path = Bundle.main.path(forResource: videosArray[index].vidName, ofType:"mp4") else {
                debugPrint("video not found")
                return
            }
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
    
    func addVideo(indexPath : IndexPath){
        
        Database.database().reference().child("Behaviors").child((ChildProfilesViewController.selectedChild?.key)!).setValue(["Videos Name" : self.videosArray[indexPath.row].vidName]) { (error, referance) in
            if error == nil {
                let alert = UIAlertController(title: "", message: "تمت الاضافة بنجاح", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "موافق", style: .cancel, handler: { action in}))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

struct Videos{
    
    let key: String?
    let vidName: String?
}
