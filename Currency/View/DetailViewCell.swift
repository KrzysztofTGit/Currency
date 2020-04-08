import UIKit

class DetailViewCell: UITableViewCell {
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
