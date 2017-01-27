//
//  SecondViewController.swift
//  Beerb
//
//  Created by John Ko on 4/22/16.
//  Copyright © 2016 John Ko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {

    @IBOutlet weak var ImageDisplay: UIImageView!
    var loaded = false
    let picker = UIImagePickerController()
    
    @IBOutlet weak var beerName: UILabel!
    
    @IBOutlet weak var beerBrewer: UILabel!
    
    @IBOutlet weak var abu: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.beerName.text = "Take a Picture!"
        self.beerBrewer.text = ""
        self.abu.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.picker.delegate = self
        self.picker.sourceType = .Camera
        
        if (self.loaded) {
            self.loaded = false
        } else {
            self.loaded = true
            presentViewController(self.picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
        let imageUpload = ImageUpload()
        imageUpload.postImage(self.ImageDisplay.image, completion: self.test)
        
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func test(jsonString: String) {
        let jsonData = self.convertStringToDictionary(jsonString as String)
        
        var name = "Uh Oh!"
        var brewer = ""
        //var score = 0.0
        if ((jsonData!["name"]) != nil) {
        
            name = jsonData!["name"] as! String
            brewer = jsonData!["brewer"] as! String
            //score = jsonData!["beer_score"] as! Double
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.beerName.text = name
            self.beerBrewer.text = brewer
            //self.abu.text = NSString(format: "Score: %.2f", score) as String
            
        })
        
    }

}
