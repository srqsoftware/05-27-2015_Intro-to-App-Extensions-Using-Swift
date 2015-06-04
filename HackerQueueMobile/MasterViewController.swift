import UIKit

class MasterViewController: UITableViewController
{
	var _dataManager: DataManager = DataManager()
	var _articles: Array<NSDictionary> = []
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		_dataManager.getArticles { (success, articles, error) -> () in
			if success
			{
				// success - bind data
				self._articles = articles
				self.tableView.reloadData()
			}
			else
			{
				// log failure
				NSLog("failure: %@", error)
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == "showDetail"
		{
		    if let indexPath = self.tableView.indexPathForSelectedRow()
			{
				let detail = segue.destinationViewController as! DetailViewController
				
				detail.title = _articles[indexPath.row]["title"] as! String?
				detail.detailItem = NSURL(string: _articles[indexPath.row]["url"] as! String)
		    }
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		// if >0 articles, set title to HackerQueue (<article count>)
		self.title = _articles.count > 0 ? String(format: "HackerQueue (%i)", _articles.count) : "HackerQueue"
		return _articles.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		
		// get article dictionary
		var article = _articles[indexPath.row] as NSDictionary
		
		// set title & detail text
		cell.textLabel?.text = (article.objectForKey("title") as! String?)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		cell.detailTextLabel?.text = article.objectForKey("comments")?.stringValue
		
		return cell
	}
}