
import UIKit

class profilesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(photo: UIImage , name: String){
        
        profileImg.image = photo
        lblName.text = name
        
    }

 

}
