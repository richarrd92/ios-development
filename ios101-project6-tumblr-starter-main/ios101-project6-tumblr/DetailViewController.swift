//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Richard M on 4/9/25.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var captionText: UITextView!
    
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Safely unwrap the optional post
        guard let post = post else {
            captionText.text = "No post data."
            return
        }

        // MARK: - Configure the caption
        let trimmedCaption = post.caption.trimHTMLTags() ?? ""
        captionText.text = trimmedCaption.isEmpty ? "No caption available." : trimmedCaption

        captionText.isScrollEnabled = true
        captionText.alwaysBounceVertical = true
        captionText.isEditable = false
        captionText.isSelectable = false // optional
        navigationItem.largeTitleDisplayMode = .never

        // MARK: - Configure the image view
        if let firstPhoto = post.photos.first {
            let imageUrl = firstPhoto.originalSize.url
            Nuke.loadImage(with: imageUrl, into: postImage)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
