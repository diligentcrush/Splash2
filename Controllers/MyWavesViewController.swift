//
//  MyWavesViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/12/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MyWavesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet  var tableView: UITableView!
    
    var groupNames = [String]()
    var groupPics = [String]()
    var passedWaveName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    let cellNib = UINib(nibName: "MyWavesTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "myWaveCell")
        
    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.tableView.backgroundColor = UIColor(red: 9.0/255.0, green: 9.0/255.0, blue: 9.0/255.0, alpha: 1.0)
        
    tableView.delegate = self
    tableView.dataSource = self
        
    self.getWaveNames()
        
    }
    
    func getWaveNames() {
        let postRoot = Database.database().reference().child("posts").observe(.value , with: {snapshot in
            
            var tempNames = [String]()
            var tempPics = [String]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let waveName = dict["waveName"] as? String,
                    let wavePic = dict["wavePic"] as? String {
                    tempNames.append(waveName as String)
                    tempPics.append(wavePic as String)
                }
            }
            
            DispatchQueue.main.async {
                self.groupNames.append(contentsOf: tempNames)
                self.groupPics.append(contentsOf: tempPics)
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openWave" {
            if let destVC = segue.destination as? GoToWaveViewController {
                destVC.waveLabel = sender as! String
                print("cunt: \(sender)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWaveCell", for: indexPath) as! MyWavesTableViewCell
        cell.waveLabel.text = self.groupNames[indexPath.row]
        cell.wavePic!.sd_setImage(with: URL(string: self.groupPics[indexPath.row]))
        //cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! MyWavesTableViewCell
        let text = cell.waveLabel.text!
        let nuts = self.groupNames[indexPath.row]

        self.performSegue(withIdentifier: "openWave", sender: nuts)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
