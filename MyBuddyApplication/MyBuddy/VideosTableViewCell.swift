

import UIKit
import AVKit

class VideosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBehName: UILabel!
    @IBOutlet weak var vidImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(videoName: String ){
        lblBehName.text = videoName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

