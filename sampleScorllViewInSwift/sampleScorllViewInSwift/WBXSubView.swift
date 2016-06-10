//
//  WBXSubView.swift
//  sampleScorllViewInSwift
//
//  Created by Mary Wang on 3/30/16.
//  Copyright © 2016 Zuse. All rights reserved.
//

import UIKit

class WBXSubView: UIImageView {
    var imageName = ""
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(image: UIImage(named: imageName))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
