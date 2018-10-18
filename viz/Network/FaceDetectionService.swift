//
//  FaceDetectionService.swift
//  viz
//
//  Created by Dov Goldberg on 19/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit
import Alamofire

protocol FaceDetectionServicing {
    func detectFaces(imageData: Data, completion: @escaping (FaceModel?)->())
}

class FaceDetectionService: NSObject, FaceDetectionServicing {
    
    private let url = "http://ogonium.synology.me:8089/detectfaces"
    private var uploadRequest: Request?
    
    func detectFaces(imageData: Data, completion: @escaping (FaceModel?)->()) {
        
        cancelRequests()
        
        Alamofire
            .upload(
                multipartFormData:{ MultipartFormData in
                    MultipartFormData.append(imageData, withName: "image_data", fileName: "image.jpeg", mimeType: "image/jpeg")
            },
                to: url) { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        self.uploadRequest = upload
                        
                        upload
                            .responseJSON { response in
                                
                                guard
                                    let json = response.result.value as? NSDictionary,
                                    let faceRectangle = json["faceRectangle"] as? NSDictionary,
                                    let faceEmotion = json["emotion"] as? String
                                    else {
                                        completion(nil)
                                        return
                                }
                                
                                let facerect = CGRect.init(faceRectangle: faceRectangle)
                                
                                completion(FaceModel.init(faceRect: facerect, faceExpression: faceEmotion))
                        }
                        
                    case .failure(_):
                        completion(nil)
                    }
        }
    }
    
    private func cancelRequests() {
        defer {
            self.uploadRequest = nil
        }
        
        guard let uploadRequest = uploadRequest else {
            return
        }
        
        uploadRequest.cancel()
    }
    
}
