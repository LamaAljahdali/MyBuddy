
import UIKit

class MyRewardsListTableViewCell: UITableViewCell {

    @IBOutlet weak var giftImg: UIImageView!
    @IBOutlet weak var rewardsNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(rewardName: String , photo: UIImage){
     
    rewardsNameLabel.text = rewardName
    giftImg.image = photo
        
    }

}
