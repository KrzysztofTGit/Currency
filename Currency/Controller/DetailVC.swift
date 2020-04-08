import UIKit
import SwiftyJSON
import Alamofire

class DetailVC: UIViewController, UITableViewDataSource {
    
    let baseUrl = "https://api.nbp.pl/api/exchangerates/rates/"
    var selectedTable: String = ""
    var selectedCurrencyCode: String = ""
    let dateFormater: DateFormatter = DateFormatter()
    var selectedFromDate: String = "2020-01-01"
    var selectedToDate: String = ""
    var tempDetailArray = [[String]]()
    var detailData = [[[String]]]()
    var numberOfDetailCells: Int = 0
    var nameOfCurrency: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayDate()
        prepareDatePickers()
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: "DetailViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        getCurrency(
            baseUrl: baseUrl,
            selectedTable: selectedTable,
            selectedCode: selectedCurrencyCode,
            selectedFromDate: selectedFromDate,
            selectedToDate: selectedToDate
        )
        currencyNameLabel.text = nameOfCurrency.capitalized
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
    }
    
    
    //MARK: - Actions
    /***************************************************************/
    
    @IBAction func fromDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let stringFromDate: String = dateFormater.string(from: fromDatePicker.date) as String
        selectedFromDate = stringFromDate
        updateTable()
    }
    
    @IBAction func toDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let stringToDate: String = dateFormater.string(from: toDatePicker.date) as String
        selectedToDate = stringToDate
        fromDatePicker.minimumDate = toDatePicker.date - 31536000
        updateTable()
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        self.getCurrency(
            baseUrl: baseUrl,
            selectedTable: selectedTable,
            selectedCode: selectedCurrencyCode,
            selectedFromDate: selectedFromDate,
            selectedToDate: selectedToDate
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Networking and Parsing
    /***************************************************************/
    
    func updateCurrencyDetail(
        json: JSON,
        selectedTable: String,
        selectedCode: String,
        selectedFromDate: String,
        selectedToDate: String
    ) {
        let numberOfDetails = json["rates"].count
        detailData.removeAll()
        for number in 0..<numberOfDetails {
            let effectiveDate = json["rates"][number]["effectiveDate"].stringValue
            tempDetailArray.append([effectiveDate])
            var mid = json["rates"][number]["mid"].doubleValue
            mid = (mid * 100).rounded() / 100
            let midString = String(mid)
            tempDetailArray.append([midString])
            detailData.append(tempDetailArray)
            tempDetailArray.removeAll()
        }
        numberOfDetailCells = detailData.count
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
        }
    }
    
    func getCurrency(
        baseUrl: String,
        selectedTable: String,
        selectedCode: String,
        selectedFromDate: String,
        selectedToDate: String) {
        self.activityIndicator.startAnimating()
        let url = baseUrl + selectedTable + "/" + selectedCode + "/" + selectedFromDate + "/" + selectedToDate
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                let currencyJSON: JSON = JSON(response.result.value ?? "")
                self.updateCurrencyDetail(
                    json: currencyJSON,
                    selectedTable: selectedTable,
                    selectedCode: selectedCode,
                    selectedFromDate: selectedFromDate,
                    selectedToDate: selectedToDate
                )
                self.activityIndicator.stopAnimating()
            } else {
                print("Error \(String(describing: response.result.error))")
                self.activityIndicator.stopAnimating()
                self.detailTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfDetailCells
    }
    
    
    //MARK: - Table View
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewCell
        cell.detailDateLabel.text = detailData[indexPath.row][0][0].capitalized
        cell.detailValueLabel.text = detailData[indexPath.row][1][0].capitalized
        return cell
    }
    
    func updateTable() {
        getCurrency(baseUrl: baseUrl, selectedTable: selectedTable, selectedCode: selectedCurrencyCode, selectedFromDate: selectedFromDate, selectedToDate: selectedToDate)
        detailTableView.reloadData()
    }
    
    func todayDate() {
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let todayDate = Date()
        let stringFromDate: String = dateFormater.string(from: todayDate) as String
        selectedToDate = stringFromDate
    }
    
    
    //MARK: - Other Functions
    /***************************************************************/
    
    func prepareDatePickers() {
        toDatePicker.maximumDate = Date()
        fromDatePicker.maximumDate = toDatePicker.date
        toDatePicker.date = Date()
    }
    
}
