//
//  ImageUpload.swift
//  Beerb
//
//  Created by John Ko on 4/23/16.
//  Copyright © 2016 John Ko. All rights reserved.
//

import Foundation
import UIKit

class ImageUpload {
    
    var finished = false
    
    func postImage(myImage: UIImage?, completion: (String)->Void!) {
        let imageData = UIImageJPEGRepresentation(myImage!.resizeToWidth(500), 1)
        
        // api config
        let request = self.factory()
        
        let param = [
            "abc"  : "12345",
            "yup" : "321",
        ]
        //let postString : String = "uid=59&asdf=123"
        //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // File
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        

        self.runRequestOnBackgroundThread(request, callback: completion)
        
    }
    
    func runRequestOnBackgroundThread(request: NSMutableURLRequest, callback:(String)->Void!) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            print(response)
            if error != nil {
                print("error=\(error)")
                callback("error")
                return
            } else {
                let jsonString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(jsonString)
                
                if jsonString == "" {
                    return
                }
                
                
                callback(jsonString as String)

            }
        }
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func factory() -> NSMutableURLRequest {
        let urlString = "http://beer-b-nodes.mybluemix.net/api/upload"
        let headers = ["accept":"application/json"]
        let request = NSMutableURLRequest( URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        return request
        
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        //func createBodyWithParameters(parameters: [String: String]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if filePathKey != nil {
            let filename = "user-profile.jpg"
            
            let mimetype = "image/jpg"
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.appendData(imageDataKey)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}