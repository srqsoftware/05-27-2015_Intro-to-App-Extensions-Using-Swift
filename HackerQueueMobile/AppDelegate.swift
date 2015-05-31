import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var _wormHole: MMWormhole = MMWormhole(applicationGroupIdentifier: "group.com.BillZink.HackerQueueMobileGroup", optionalDirectory: "watch")
	var _dataManager = DataManager()
	var taskID: UIBackgroundTaskIdentifier?
	
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
	{
		return true
	}
	
	func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!)
	{
//		taskID = UIApplication.sharedApplication().beginBackgroundTaskWithName("getArticles", expirationHandler: { () -> Void in })
		
		self._dataManager.getArticles
		{
			(success, articles, error) -> () in
			
			var result: Dictionary<String, AnyObject> = ["success": success]
			
			if success
			{
				result["articles"] = articles
			}
			else
			{
				result["error"] = error
			}
			
			self._wormHole.passMessageObject(result, identifier: "articles")
			
//			UIApplication.sharedApplication().endBackgroundTask(self.taskID!)
		}
		
		// wake app
		reply(nil)
	}
}