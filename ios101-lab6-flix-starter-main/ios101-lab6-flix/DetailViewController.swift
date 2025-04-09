//
//  DetailViewController.swift
//  ios101-lab6-flix
//
//  Created by Richard M on 4/9/25.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAvgLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // Property to store the passed in movie
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // MARK: - Configure the labels
        
        navigationItem.largeTitleDisplayMode = .never

        titleLabel.text = movie.title
        captionLabel.text = movie.overview

        // Unwrap the optional vote average
        if let voteAverage = movie.voteAverage {

            // voteAverage is a Double
            // We can convert it to a string using `\(movie.voteAverage)` (aka *String Interpolation*)
            // inside string quotes (aka: *string literal*)
            voteAvgLabel.text = "Vote Average: \(voteAverage)"
        } else {

            // if vote average is nil, set vote average label text to empty string
            voteAvgLabel.text = ""
        }

        // The `releaseDate` is a `Date` type. We can convert it to a string using a `DateFormatter`.
        // Create a date formatter
        let dateFormatter = DateFormatter()

        // Set the date style for how the date formatter will display the date as a string.
        // You can experiment with other settings like, `.short`, `.long` and `.full`
        dateFormatter.dateStyle = .medium

        // Unwrap the optional release date
        if let releaseDate = movie.releaseDate {

            // Use the the date formatter's `string(from: Date)` method to convert the date to a string
            let releaseDateString = dateFormatter.string(from: releaseDate)
            releaseDateLabel.text = "Release Date: \(releaseDateString)"
        } else {

            // if release date is nil, set release date label text to empty string
            releaseDateLabel.text = ""
        }
        
        // MARK: - Configure the image views

        // Unwrap the optional poster path
        if let posterPath = movie.posterPath,

        // Create a url by appending the poster path to the base url. https://developers.themoviedb.org/3/getting-started/images
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {

            // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
            Nuke.loadImage(with: imageUrl, into: posterImage)
        }

        // Unwrap the optional backdrop path
        if let backdropPath = movie.backdropPath,

        // Create a url by appending the backdrop path to the base url. https://developers.themoviedb.org/3/getting-started/images
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + backdropPath) {

            // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
            Nuke.loadImage(with: imageUrl, into: backDropImage)
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
