import UIKit
import CoreLocation
import CoreData



private let dateFormatter: NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateStyle = .MediumStyle
  formatter.timeStyle = .ShortStyle
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  var managedObjectContext: NSManagedObjectContext!

  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
    
  var descriptionText = ""
  var categoryName = "No Category"
    var date = NSDate()
    
  @IBAction func done() {
    let hudView = HudView.hudInView(navigationController!.view, animated: true)
    hudView.text = "Tagged"
    // 1
    let location = NSEntityDescription.insertNewObjectForEntityForName( "Location", inManagedObjectContext: managedObjectContext)
        as Location
    // 2
    location.locationDescription = descriptionText
    location.category = categoryName
    location.latitude = coordinate.latitude
    location.longitude = coordinate.longitude  
    location.date = date
    location.placemark = placemark
    // 3
    var error: NSError?
    if !managedObjectContext.save(&error) {
        println("Error: \(error)")
        abort() }
    
    afterDelay(0.6) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  @IBAction func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    descriptionTextView.text = descriptionText
    categoryLabel.text = categoryName
    
    latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
    longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
    
    if let placemark = placemark {
      addressLabel.text = stringFromPlacemark(placemark)
    } else {
      addressLabel.text = "No Address Found"
    }
    
    dateLabel.text = formatDate(date)

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    descriptionTextView.frame.size.width = view.frame.size.width - 30
  }

  func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
    let point = gestureRecognizer.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(point)

    if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
      return
    }
    
    descriptionTextView.resignFirstResponder()
  }

  func stringFromPlacemark(placemark: CLPlacemark) -> String {
    return
      "\(placemark.subThoroughfare) \(placemark.thoroughfare), " +
      "\(placemark.locality), " +
      "\(placemark.administrativeArea) \(placemark.postalCode)," +
      "\(placemark.country)"
  }

  func formatDate(date: NSDate) -> String {
    return dateFormatter.stringFromDate(date)
  }

  // MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 && indexPath.row == 0 {
      return 88
      
    } else if indexPath.section == 2 && indexPath.row == 2 {
      addressLabel.frame.size = CGSizeMake(view.bounds.size.width - 115, 10000)
      addressLabel.sizeToFit()
      addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
      return addressLabel.frame.size.height + 20
      
    } else {
      return 44
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if indexPath.section == 0 || indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      descriptionTextView.becomeFirstResponder()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destinationViewController as CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }
  
  @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
    let controller = segue.sourceViewController as CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
}

extension LocationDetailsViewController: UITextViewDelegate {
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
      
    descriptionText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)

    return true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    descriptionText = textView.text
  }
}
