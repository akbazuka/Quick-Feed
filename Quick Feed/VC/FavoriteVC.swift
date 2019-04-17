//
//  FavoriteVC.swift
//  Quick Feed
//
//  Created by AK on 4/12/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    static var favoriteArray: [Recipe] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteVC.favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = FavoriteVC.favoriteArray[indexPath.row].name 
        return cell
    }
}
