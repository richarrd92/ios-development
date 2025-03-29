//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

extension String {
    var removingPTags: String {
        let regexPattern = "(?i)</?p>"
        return self.replacingOccurrences(of: regexPattern, with: "", options: .regularExpression)
    }
}


class ViewController: UIViewController, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print("🍏 numberOfRowsInSection called with posts count: \(posts.count)")
//        return posts.count
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("🍏 cellForRowAt called for row: \(indexPath.row)")

        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)

//        // Create the cell
//        let cell = UITableViewCell()
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
//
//        // Get the movie-associated table view row
//        let post = posts[indexPath.row]
//
//        // Configure the cell (i.e., update UI elements like labels, image views, etc.)
//        cell.textLabel?.text = post.caption.removingPTags
        
        // Set the text on the labels
//        cell.captionLabel.text = post.summary.removingPTags
////        cell.summaryLabel.text = post.summary
//        
//        // Load image using Nuke
//        if let imageUrl = post.photos.first?.originalSize.url {
//            Nuke.loadImage(with: imageUrl, into: cell.posterImageView)
//        } else {
//            cell.posterImageView.image = UIImage(named: "placeholder") // Default placeholder image
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = articles[indexPath.row]
        
        // Reset image and placeholders if reused
        resetImageView(cell.newsImageView)
        
        // Set the text on the labels
        cell.titleLabel.text = article.title
        cell.descriptionLabel.text = article.description ?? "No Description"
        
        // Load image using Nuke
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
//            Nuke.loadImage(with: url, into: cell.newsImageView)
            // Show loading spinner while the image is loading
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.center = cell.newsImageView.center
            cell.newsImageView.addSubview(spinner)

            // Load the image using Nuke
            Nuke.loadImage(with: url, into: cell.newsImageView) { _ in
                // Stop the spinner when the image is loaded
                spinner.stopAnimating()
                spinner.removeFromSuperview()
            }
        } else {
//            cell.newsImageView.image = UIImage(named: "placeholder") // Default placeholder image
            
            // Set a gradient background for the placeholder
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.newsImageView.bounds
            gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
            // Apply the gradient to the image view
            cell.newsImageView.layer.insertSublayer(gradientLayer, at: 0)
            cell.newsImageView.image = nil  // Ensure no image is shown
            
            // Add "No Image" placeholder text
            let noImageLabel = UILabel()
            noImageLabel.text = "No Image"
            noImageLabel.textColor = .white
            noImageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            noImageLabel.translatesAutoresizingMaskIntoConstraints = false
            noImageLabel.textAlignment = .center
            noImageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // Optional: Add background for contrast
            
            // Add the label as a subview of the image view
            cell.newsImageView.addSubview(noImageLabel)
            
            // Add constraints to center the label in the image view
            NSLayoutConstraint.activate([
                noImageLabel.centerXAnchor.constraint(equalTo: cell.newsImageView.centerXAnchor),
                noImageLabel.centerYAnchor.constraint(equalTo: cell.newsImageView.centerYAnchor),
            ])
        }
        
        // Return the cell for use in the respective table view row
        return cell

    }
    
    
    private func resetImageView(_ imageView: UIImageView) {
        // Remove any existing gradient layer and text
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
        imageView.layer.sublayers?.removeAll()  // Remove gradient if exists
    }
    


    @IBOutlet weak var tableView: UITableView!
    
//    private var posts: [Post] = []
    private var articles: [NewsArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        fetchPosts()
    }



    func fetchPosts() {
//        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2025-02-28&sortBy=publishedAt&apiKey=9eceb9c322b9468e91fc1574317067c9")!
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
//                let blog = try JSONDecoder().decode(Blog.self, from: data)
//
//                DispatchQueue.main.async { [weak self] in
//
//                    let posts = blog.response.posts
//
//
//                    print("✅ We got \(posts.count) posts!")
//                    for post in posts {
//                        print("🍏 Summary: \(post.summary)")
//                    }
//                    
//                    print("🍏 Fetched and stored \(posts.count) movies")
//
//                    self?.posts = posts
//                    self?.tableView.reloadData()
//                    
//                }
                
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)

                DispatchQueue.main.async {
                    self.articles = newsResponse.articles
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
