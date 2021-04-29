//
//  ArchiveTableViewController.swift
//  mobileDevelopmentLab1.1
//
//  Created by Anastasiia Poliukovych on 15.02.2021.
//

import UIKit

class ArchiveTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var label: UILabel!
    var search = UISearchController()
    static var filteredData: [[String]] = [[],[],[],[],[]]
    var countOfFilteredBook: Int = 0
    var index = Int()
    let dataFromBL = DataFromBooksList()
    static var data: [[String]] = [[],[],[],[],[]]
    let booksId: [String] = ["BooksList","9780321856715","9780321862969","9781118841471","9781430236054","9781430237105","9781430238072","9781430245124","9781430260226","9781449308360","9781449342753" ]
    
    var isVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "cell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        search.obscuresBackgroundDuringPresentation = false // to scroll table view while searching
        navigationItem.searchController?.searchBar.placeholder = "Search by title"
        
        ArchiveTableViewController.data = dataFromBL.main()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(insertRow))
        
        getData(forRequest: "ab")
    }
    
    @objc func insertRow() {
        
        let index = ArchiveTableViewController.data[0].count
        self.tableView.performBatchUpdates({
            ArchiveTableViewController.data[0].insert(AddNewBookVC.title ,at: index)
            ArchiveTableViewController.data[1].insert(AddNewBookVC.subtitle ,at: index)
            ArchiveTableViewController.data[3].insert("$"+AddNewBookVC.price,at: index)
            ArchiveTableViewController.data[2].insert("no value",at: index)
            ArchiveTableViewController.data[4].insert("defaultImage",at: index)
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }, completion: { result in
            self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        })
    }
}
    
    
   
// MARK: - Table view data source

extension ArchiveTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return countOfFilteredBook
        }
        return ArchiveTableViewController.data[0].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableCell
        var dataForCell = [[String]]()
        if isSearching() {
            dataForCell = ArchiveTableViewController.filteredData
        } else {
            dataForCell = ArchiveTableViewController.data
        }
        cell.set(data: dataForCell, index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .normal, title: "delete", handler: {(action, view, success) in
            tableView.performBatchUpdates({
                for i in 0...4{
                    ArchiveTableViewController.data[i].remove(at: indexPath.row)
                    }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: nil )
        })
        swipe.image = #imageLiteral(resourceName: "leftSwipe@x3")
        swipe.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return UISwipeActionsConfiguration(actions: [swipe])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailAboutBookViewController") as! detailAboutBookViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let selectedRow = self.tableView.indexPathForSelectedRow!.row
        if !searchBarIsEmpty() {
            detailAboutBookViewController.selectedValue = ArchiveTableViewController.filteredData[0][selectedRow]
        } else {
            detailAboutBookViewController.selectedValue = ArchiveTableViewController.data[0][selectedRow]
        }
    }
}


// MARK: - Search

extension ArchiveTableViewController : UISearchResultsUpdating {
    
    func searchBarIsEmpty() -> Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
 //       let enteredDataInSearchController: String = searchController.searchBar.text!.lowercased()
        
        ArchiveTableViewController.filteredData = [[],[],[],[],[]]
        countOfFilteredBook = 0
        for i in 0..<ArchiveTableViewController.data[0].count{
            if  ArchiveTableViewController.data[0][i].lowercased().contains(searchController.searchBar.text!.lowercased()){
                countOfFilteredBook += 1
                for j in 0...4{
                    ArchiveTableViewController.filteredData[j].append( ArchiveTableViewController.data[j][i])
                }
            }
        }
        if search.isActive && ArchiveTableViewController.filteredData[0].count == 0 {
            label.text = "no result"
        } else if search.isActive && ArchiveTableViewController.filteredData[0].count != 0 {
            label.text = "result of the searching"
        } else if !search.isActive{
            label.text = "your books archive"
        }
        tableView.reloadData()
    }
}


// MARK: - Get data from the internet
extension ArchiveTableViewController{
    
    func getData(forRequest req: String){
        let urlString = "https://api.itbook.store/1.0/search/\(req)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("we have some error")
                    return
                }
                guard let data = data else {return}
                let stringData = String(data: data, encoding: .utf8)
                print(stringData ?? "no")
            }
        }.resume()
    }
}
