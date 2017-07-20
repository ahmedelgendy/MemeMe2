//
//  MemeDetailsController.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 23/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    
    var meme : Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.meme.memedImage
    }
    
}
