//
//  MasterViewController.swift
//  Satisfy
//
//  Created by Pierre on 17/04/2018.
//  Copyright © 2018 boudonpierre. All rights reserved.
//

import UIKit
import SwiftyJSON

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var vm: ViewModel!
    
    private let refControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm = APIManager.shared.vm
        APIManager.shared.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.tableView.backgroundColor = UIColor.black
        refControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.tableView.refreshControl = refControl
    }
    
    @objc private func refreshData(_ sender: Any) {
        APIManager.shared.getInfos()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = self.vm.pods[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.pods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let pod = self.vm.pods[indexPath.row]
        cell.textLabel!.text = pod.satisfactions.first?.namePod
        cell.textLabel?.textColor = UIColor.white
        
        cell.backgroundColor = UIColor.black
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


}

extension MasterViewController: APIManagerDelegate {
    func getCallback(statusCode: Int, data: Data) {
        if statusCode == 200 {
            let json = try? JSON(data: data)
            let pod = Pod()
            
            for j in json! {
                pod.satisfactions.append(Satisfaction(json: j.1))
            }
            
            self.vm.pods = [Pod]()
            self.vm.pods.append(pod)
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
