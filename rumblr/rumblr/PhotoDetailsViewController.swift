//
//  PhotoDetailsViewController.swift
//  rumblr
//
//  Created by Angela Yu on 9/13/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailCaptionLabel: UILabel!
    
    var photoURL: URL?
    var caption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageURL = photoURL {
            detailImageView.setImageWith(imageURL)
        }
        
        detailCaptionLabel.text = caption
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
