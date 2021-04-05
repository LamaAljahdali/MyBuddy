
import UIKit

class behaviorsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var behNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(behaviorName: String){
        behNameLbl.text = behaviorName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
