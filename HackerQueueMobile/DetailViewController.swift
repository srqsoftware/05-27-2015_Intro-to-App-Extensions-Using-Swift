import UIKit

class DetailViewController: UIViewController
{
	@IBOutlet weak var detailWebView: UIWebView!
	
	var detailItem: NSURL?
	
	func configureView()
	{
		// set web view url
		let request = NSURLRequest(URL: detailItem!)
		self.detailWebView.loadRequest(request)
	}
	
	override func viewWillAppear(animated: Bool)
	{
		// config on will appear
		configureView()
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		// clear title
		title = ""
	}
}