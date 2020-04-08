import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var currencyCellLabel: UILabel!
    @IBOutlet weak var codeCellLabel: UILabel!
    @IBOutlet weak var midCellLabel: UILabel!
    @IBOutlet weak var dateCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
