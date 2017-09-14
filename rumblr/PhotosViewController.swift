//
//  PhotosViewController.swift
//  
//
//  Created by Angela Yu on 9/13/17.
//
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var postsTable: UITableView!
    
    var posts: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        
        netRequest(postsTable, targetUrl: URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!, refreshControl: refreshControl)
        
        // add refresh control to table view
        postsTable.insertSubview(refreshControl, at: 0)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsTable.rowHeight = 240;
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTable.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let imageUrl = getImageUrlFromPost(postsTable, cellforRowAt: indexPath)
        
        cell.postImageView.setImageWith(URL(string: imageUrl)!)
        
        return cell
    }
    
    // Makes a network request
    // Populates the posts dictionary with the response data
    // Fills in the table
    // Ends refreshing
    func netRequest(_ tableView: UITableView, targetUrl: URL, refreshControl: UIRefreshControl) {
        // Create the URLRequest
        let request = URLRequest(url: targetUrl)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.postsTable.reloadData()
                        
                        // Tell the refreshControl to stop spinning
                        print("refreshed!")
                        refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    // Retrive the URL for the image of a post at the indexPath of the selected cell
    func getImageUrlFromPost(_ tableView: UITableView, cellforRowAt indexPath: IndexPath) -> String {
        let post = posts[indexPath.row]
        var result = String()
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            result = imageUrlString!
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        return result
        
    }

    // Retrive the caption for the image of a post at the indexPath of the selected cell
    func getCaptionFromPost(_ tableView: UITableView, cellforRowAt indexPath: IndexPath) -> String {
        let post = posts[indexPath.row]
        let caption = post["caption"] as! String
        print (indexPath.row)
        print (caption)
        return caption
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        netRequest(postsTable, targetUrl: URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!, refreshControl: refreshControl)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! PhotoDetailsViewController
        let indexPath = postsTable.indexPath(for: sender as! UITableViewCell)!
        
        let photoURL = getImageUrlFromPost(postsTable, cellforRowAt: indexPath)
        let caption = getCaptionFromPost(postsTable, cellforRowAt: indexPath)
        detailView.photoURL = URL(string: photoURL)
        detailView.caption = caption
    }

}
