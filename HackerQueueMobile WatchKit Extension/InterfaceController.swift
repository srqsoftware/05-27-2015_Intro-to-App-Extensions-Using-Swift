import WatchKit
import Foundation

class InterfaceController: WKInterfaceController
{
	@IBOutlet weak var reloadButton: WKInterfaceButton!
	@IBOutlet weak var mainTable: WKInterfaceTable!
	
	var _wormHole: MMWormhole = MMWormhole(applicationGroupIdentifier: "group.com.BillZink.HackerQueueMobileGroup", optionalDirectory: "watch")
	private var _data: Array<NSDictionary>?
	
    override func awakeWithContext(context: AnyObject?)
	{
        super.awakeWithContext(context)
		
		self._wormHole.listenForMessageWithIdentifier("articles", listener:
		{
			(response) -> Void in
			
			NSLog("articles received")
			
			var success = response["success"] as! Bool
			
			if success
			{
				let dictionaryResult = response["articles"] as? Array<NSDictionary>
				self._data = dictionaryResult
				self._bindData()
			}
			else
			{
				// error
			}
		})
		
		self.reloadTap()
    }
	
	private func _bindData()
	{
		var rowCount = _data?.count as Int!
		rowCount = rowCount <= 20 ? rowCount : 20
		
		mainTable.setNumberOfRows(rowCount, withRowType: "ArticleCell")
		
		for var i = 0; i < rowCount; i++
		{
			let cell = mainTable.rowControllerAtIndex(i) as! ArticleCell
			let dataRow: NSDictionary = _data![i]
			
			cell.titleLabel.setText(dataRow["title"] as! String?)
			
			if let commentCount: NSNumber = dataRow["comments"] as? NSNumber
			{
				cell.numberOfCommentsLabel.setText(commentCount.stringValue)
			}
			else
			{
				cell.numberOfCommentsLabel.setText("0")
			}
		}
	}

    override func willActivate()
	{
        super.willActivate()
    }

    override func didDeactivate()
	{
        super.didDeactivate()
    }
	
	@IBAction func reloadTap()
	{
		NSLog("reloadTap")
		
		// send wake request
		WKInterfaceController.openParentApplication(["command": "wake"], reply:
		{
			(response, error) -> Void in
			
			NSLog("Parent app awake")
		})
	}
}