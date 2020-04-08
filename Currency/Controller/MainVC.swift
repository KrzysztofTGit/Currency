import UIKit
import SwiftyJSON
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let baseUrl = "https://api.nbp.pl/api/exchangerates/tables/"
    let cellIdentifier = "MainCell"
    var numberOfCells: Int = 0
    var tempArray = [[String]]()
    var currencyData = [[[String]]]()
    var selectedTable: String = "A"
    var selectedCode = ""
    var nameOfCurrency: String = ""
    var currentDateAndTime = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        self.getCurrency(table: selectedTable)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
    }
    
    
    //MARK: - Actions
    /***************************************************************/
    
    @IBAction func tableSelector(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedTable = "A"
            self.getCurrency(table: selectedTable)
        case 1:
            selectedTable = "B"
            self.getCurrency(table: selectedTable)
        default:
            break
        }
    }
    
    @IBAction func reloadPressed(_ sender: UIButton) {
        self.getCurrency(table: selectedTable)
    }
    
    
    //MARK: - Networking and Parsing
    /***************************************************************/
    
    func updateCurrencyData(json: JSON, tableType: String) {
        let numberOfRows = json[0]["rates"].count
        currencyData.removeAll()
        for number in 0..<numberOfRows {
            let currency = json[0]["rates"][number]["currency"].stringValue
            tempArray.append([currency])
            let code = json[0]["rates"][number]["code"].stringValue
            tempArray.append([code])
            var mid = json[0]["rates"][number]["mid"].doubleValue
            mid = (mid * 10000).rounded() / 10000
            let midString = String(mid)
            tempArray.append([midString])
            currencyData.append(tempArray)
            tempArray.removeAll()
            updateTime()
        }
        numberOfCells = currencyData.count
        selectedCode = "test"
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    func getCurrency(table: String) {
        self.activityIndicator.startAnimating()
        Alamofire.request(baseUrl + table).responseJSON { response in
            if response.result.isSuccess {
                let currencyJSON: JSON = JSON(response.result.value ?? "")
                self.updateCurrencyData(json: currencyJSON, tableType: table)
                self.activityIndicator.stopAnimating()
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    
    //MARK: - Table View
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! TableViewCell
        cell.currencyCellLabel.text = currencyData[indexPath.row][0][0].capitalized
        cell.midCellLabel.text = currencyData[indexPath.row][2][0]
        cell.codeCellLabel.text = currencyData[indexPath.row][1][0]
        cell.dateCellLabel.text = currentDateAndTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCode = currencyData[indexPath.row][1][0]
        nameOfCurrency = currencyData[indexPath.row][0][0]
        self.performSegue(withIdentifier: "goToSecondVC", sender: self)
    }
    
    
    //MARK: - Other Functions
    /***************************************************************/
    
    func updateTime() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = Date()
        currentDateAndTime = dateFormatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondVC" {
            let destinationVC = segue.destination as! DetailVC
            destinationVC.selectedCurrencyCode = selectedCode
            destinationVC.selectedTable = selectedTable
            destinationVC.nameOfCurrency = nameOfCurrency
        }
    }

}
