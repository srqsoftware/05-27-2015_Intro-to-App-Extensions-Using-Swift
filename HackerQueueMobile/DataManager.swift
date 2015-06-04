import Foundation
import AFNetworking

class DataManager: NSObject
{
	var requestManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
	
	// HQ API urls
	var urls: Array<String> = ["http://104.131.190.186:3000/ycomb", "http://104.131.190.186:3000/lobster", "http://104.131.190.186:3000/rp"]
	
	func getArticles (callback: (success: Bool, articles: Array<NSDictionary>!, error: NSError!) -> ())
	{
		let combinedArticles: NSMutableArray = NSMutableArray()
		var completedCalls = 0;
		var hasError = false;
		
		for url: String in urls
		{
			requestManager.GET(url, parameters: nil, success:
			{
				// success
				(request: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
				
				// add each article to array
				for resultItem in result as! Array<AnyObject>
				{
					combinedArticles.addObject(resultItem)
				}
				
				// increment, if we're done w/no errors, do callback
				if ++completedCalls == 3 && !hasError
				{
					let combinedArticlesArray = NSArray(array: combinedArticles) as! [NSDictionary]
					
					callback(success: true, articles: combinedArticlesArray, error: nil)
				}
			}, failure:
			{
				// failure
				(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
				
				// tell future requests that we failed
				hasError = true;
				
				// error callback
				callback(success: false, articles: nil, error: error)
			})
		}
	}
}