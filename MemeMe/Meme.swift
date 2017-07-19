//
//  Meme.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 21/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText : String
    var bottomText: String
    var originalImage : UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage : UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
