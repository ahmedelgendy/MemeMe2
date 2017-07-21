//
//  CollectionViewController.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 22/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import Foundation
import UIKit

class CollectipnViewController: UICollectionViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        setFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    @IBAction func showMemeEditor(){
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "memeViewController") as! MemeViewController
        present(storyboard, animated: true, completion: nil)
    }
    
    func setFlowLayout(){
        let space:CGFloat = 3.0
        let dims = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dims, height: dims)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = appDelegate.memes[(indexPath as IndexPath).row].memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailsController") as! MemeDetailsController
        controller.meme = appDelegate.memes[(indexPath as IndexPath).row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
