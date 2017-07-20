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

    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
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
