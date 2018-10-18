//
//  FaceModel.swift
//  viz
//
//  Created by Dov Goldberg on 19/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

class FaceModel: NSObject {
    let faceRect: CGRect?
    let faceExpression: String
    
    init(faceRect: CGRect, faceExpression: String) {
        self.faceRect = faceRect
        self.faceExpression = faceExpression
    }
}
