//
//  TableViewController.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 21/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func showMemeEditor(){
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "memeViewController") as! MemeViewController
        present(storyboard, animated: true, completion: nil)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "memeTable")!
        let meme = appDelegate.memes[(indexPath as IndexPath).row]
        cell.textLabel?.text = meme.topText + "  " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        print("cell initiated", indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailsController") as! MemeDetailsController
        controller.meme = appDelegate.memes[(indexPath as IndexPath).row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
