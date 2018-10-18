//
//  CGRectExtension.swift
//  viz
//
//  Created by Dov Goldberg on 18/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    
    init(faceRectangle: NSDictionary) {
        
        let _x = faceRectangle.value(forKey: "left") as! Double
        let _y = faceRectangle.value(forKey: "top") as! Double
        let _width = faceRectangle.value(forKey: "width") as! Double
        let _height = faceRectangle.value(forKey: "height") as! Double
        
        self.init(x: _x, y: _y, width: _width, height: _height)
    }
}
