//
//  ViewController.swift
//  reddit
//
//  Created by Kyle Johnson on 8/2/17.
//  Copyright © 2017 Kyle Johnson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var articles = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "reddit - r/all"
        
        let requestURL = "https://newsapi.org/v1/articles?source=reddit-r-all&sortBy=top&apiKey=4c8eff52eaa54f178731f0350adb17f4"
        
        if let url = URL(string: requestURL) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                
                if json["status"].stringValue == "ok" {
                    parse(json: json)
                }
            }
        }
    }
    
    func parse(json: JSON) {
        for article in json["articles"].arrayValue {
            let author = article["author"].stringValue
            let description = article["description"].stringValue
            let publishedAt = article["publishedAt"].stringValue
            let title = article["title"].stringValue
            let url = article["url"].stringValue
            let urlToImage = article["urlToImage"].stringValue
            let obj = ["author": author, "description": description, "publishedAt": publishedAt, "title": title, "url": url, "urlToImage": urlToImage]
            articles.append(obj)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        
        let fullTitle = article["title"]?.components(separatedBy: " • ")
        let title = (fullTitle?[0])!

        if (fullTitle?.count)! > 1 {
            cell.subredditLabel?.text = "\((fullTitle?[1])!)"
            cell.authorLabel?.text = "u/\(article["author"]!)"
        } else {
            cell.subredditLabel?.text = "external"
            cell.authorLabel?.text = article["author"]!
        }
        
        cell.titleLabel?.text = title
        cell.descriptionLabel?.text = article["description"]
        
        if let url = NSURL(string: article["urlToImage"]!) {
            if let data = NSData(contentsOf: url as URL) {
                cell.imagePreview?.image = UIImage(data: data as Data)
            }
        }

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
