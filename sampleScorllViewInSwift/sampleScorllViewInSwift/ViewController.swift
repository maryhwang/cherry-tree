import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight:CGFloat = 60.0
    var sampleTableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sampleTableView = UITableView(frame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height), style:.Grouped)
        //self.sampleTableView = UITableView(frame:CGRectMake(0,0,self.view.frame.size.width, kCellHeight * 1.5), style:.Grouped)
        
        sampleTableView.dataSource = self
        sampleTableView.delegate = self
        sampleTableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(sampleTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.sampleTableView.reloadData()
    }
    
    func adjustViewForRotation() {
        if UIDevice.currentDevice().orientation.isLandscape {
            self.sampleTableView.hidden = false;
            self.sampleTableView.reloadData()
        } else {
            self.sampleTableView.hidden = true;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifierPortrait = "CellPortrait";
        let CellIdentifierLandscape = "CellLandscape";
        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifier)

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .None
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight))
            if indexPath.row == 0{
                // render an image view
                let activeSpeaker = createSpeakerView(getImageName())
                
                cell?.contentView.addSubview(activeSpeaker)
            }
            else if indexPath.row == 1 {
                horizontalScrollView.miniAppearPxOfLastItem = 30
                horizontalScrollView.uniformItemSize = CGSizeMake(80, 50)
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for _ in 1...50{
                    let imageName = getImageName();
                    
                    let smallView = WBXSubView(imageName: imageName)

                    // add tap
                    let subViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSubViewTap(_:)))
                    
                    smallView.addGestureRecognizer(subViewTap)
                    // very important to get tap event
                    smallView.userInteractionEnabled = true
                    horizontalScrollView.addItem(smallView)
                }
            }
            
            cell?.contentView.addSubview(horizontalScrollView)
            
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: kCellHeight))
            
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell!.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        }
        return cell!
        
    }
    
    func createSpeakerView(fileName : String) -> UIView {
        /*
        let activeImage:UIImage? = UIImage(named: getImageName());
        
        let activeSpeeker = UIImageView(image: activeImage)
        */
        //let activeImage:UIImage? = UIImage(named: getImageName());
        let activeImage:UIImage? = UIImage(named: fileName);

        let activeSpeeker = UIImageView(image: activeImage)
        
        activeSpeeker.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.height - kCellHeight * 2)
        
        // set tag of the view
        activeSpeeker.tag = 100

        return activeSpeeker
    }
    
    // handle tap
    func handleSubViewTap(sender: UITapGestureRecognizer) {
        //NSLog("handleSubViewTap called!!!")
        // remove the cell1 view and create another view
        // NSIndexPath
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        // get old view name
        
        sampleTableView.cellForRowAtIndexPath(indexPath)?.contentView.viewWithTag(100)?.removeFromSuperview()

        let sourceView = sender.view as! WBXSubView
        
        let fileName = sourceView.imageName
        
        // recreate the view
        sampleTableView.cellForRowAtIndexPath(indexPath)?.contentView.addSubview(createSpeakerView(fileName))
    }
    
    func getImageName() -> String {
        var imageName = "sampleImage2.png"
        
        let imageNumber = Int(arc4random_uniform(6) + 1)
        imageName = "sampleImage\(imageNumber).png"
        
        return imageName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var cellHeight:CGFloat = kCellHeight

        if indexPath.row == 0 {
            cellHeight = self.view.frame.height - kCellHeight * 2
        } else if indexPath.row == 1 {
            cellHeight = kCellHeight
        }
        
        return cellHeight
    }
    
}

