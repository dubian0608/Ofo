//
//  HomePageViewController.swift
//  ofo
//
//  Created by Zhang, Frank on 10/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import SWRevealViewController
import FTIndicator

class HomePageViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin: MyPinAnnotation!
    var pinView: MAPinAnnotationView!
    var selectedAnno: SelectedAnnotation!
    var selectedView: CustomAnnotationView!
    var walkManager: AMapNaviWalkManager!
    var an: MAAnnotationView!
    var annotations: [MAPointAnnotation] = []
    var searchNearBy = true
    var isShowPath = false
    var waitView: UIView!
    var waitImage: UIImageView!
    var waitLabel: UILabel!
    
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var panelView: UIView!
    
    @IBAction func refreshButTap(_ sender: UIButton) {
//        refreshButton.setBackgroundImage(#imageLiteral(resourceName: "leftBottomBackgroundImage"), for: .normal)
//        refreshButton.setImage(#imageLiteral(resourceName: "leftBottomRefreshImage"), for: .normal)
        mapView.removeAnnotation(selectedAnno)
        mapView.removeOverlays(mapView.overlays)
        refreshLabel.text = "刷新"
        UIView.animate(withDuration: 0.5, animations: {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            sender.imageView?.transform = .identity
        }, completion: nil)
        searchNearBy = true
        searchBike(center: mapView.userLocation.coordinate)
        pin.isLockedToScreen = true
        isShowPath = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        view.bringSubview(toFront: panelView)
        
        mapView.delegate = self
        mapView.zoomLevel = 15
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
       
        
        search = AMapSearchAPI()
        search.delegate = self
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self

        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth = view.frame.width * 0.75
            navigationItem.leftBarButtonItem?.target = revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        let annotationID = "customAnnotation"
        selectedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) as? CustomAnnotationView
        
        if selectedView == nil{
            selectedView = CustomAnnotationView(annotation: selectedAnno, reuseIdentifier: annotationID)
        }
        
        setWaitView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - search bike
    func searchBike(center: CLLocationCoordinate2D) {
        
        searchCenter(center: center)
        mapView.centerCoordinate = center
        
    }
    
    func searchCenter(center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.keywords = "餐馆"
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.radius = 500
        request.requireExtension = true
        
        
        search.aMapPOIAroundSearch(request)
    }
    
    //MARK: - Map search delegate
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        mapView.removeAnnotations(annotations)
        if response.count > 0 {
            annotations = response.pois.map{
                let annotation = MAPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
                if $0.distance < 200{
                    annotation.title = "红包车"
                    annotation.subtitle = "骑行十分钟得红包"
                }else{
                    annotation.title = "正常车"
                    annotation.subtitle = "欢迎使用小黄车"
                }
                
                return annotation
            }
        }
        mapView.addAnnotations(annotations)
        if searchNearBy{
            searchNearBy = false
            mapView.showAnnotations(annotations, animated: true)
            
            mapView.centerCoordinate = mapView.userLocation.coordinate
        }

    }
    
    //MARK: - Map view delegate
    
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        
        mapView.centerCoordinate = mapView.userLocation.coordinate
        pin.coordinate = mapView.centerCoordinate
       
        pin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        searchBike(center: mapView.userLocation.coordinate)
        
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAUserLocation {
            return nil
        }
        if annotation is MyPinAnnotation{
            let pinID = "MyPin"
            pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? MAPinAnnotationView
            if pinView == nil{
                pinView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pinID)
            }
            pinView.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            pinView.canShowCallout = false
            pinView.centerOffset = CGPoint(x: 0, y: -10)
            
            return pinView
        }
        
        if annotation is SelectedAnnotation{
            
            selectedView.image = nil
            selectedView.canShowCallout = true
            selectedView.calloutOffset = CGPoint(x: 0, y: -#imageLiteral(resourceName: "HomePage_nearbyBike").size.height * 1.15)
            selectedView.isSelected = true
            return selectedView
        }
        
        let annotationID = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) as? MAPinAnnotationView
        
        if annotationView == nil{
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
        }
        
        if annotation.title == "正常车" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }else{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        

        annotationView?.canShowCallout = false
//        annotationView?.animatesDrop = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction{
            refreshLabel.text = "定位"
            if !isShowPath{
                searchBike(center: pin.coordinate)
                pinViewAnimate()
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aView in aViews {
            if aView.annotation is MyPinAnnotation {
                continue
            }
            if aView.annotation is SelectedAnnotation{
                continue
            }
            aView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
                aView.transform = .identity
//                aView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: nil)

        }
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        waitImageAnimate()
        mapView.removeAnnotation(selectedAnno)
        if an != nil {
            an.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
                self.an.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }

        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(pin.coordinate.latitude), longitude: CGFloat(pin.coordinate.longitude))
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(view.annotation.coordinate.latitude), longitude: CGFloat(view.annotation.coordinate.longitude))
        
        walkManager.calculateWalkRoute(withStart: [startPoint!], end: [endPoint!])
        
        selectedAnno = SelectedAnnotation()
        selectedAnno.coordinate = view.annotation.coordinate
        
        an = view
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: nil)
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            pin.isLockedToScreen = false
            isShowPath = true
            let rect = overlay.boundingMapRect
            let scale = rect.size.width / Double(view.bounds.width)
//            print(scale, "##############")
            mapView.visibleMapRect = MAMapRect(origin: MAMapPoint(x: rect.origin.x - 100 * scale, y: rect.origin.y - 150 * scale), size: MAMapSize(width: rect.size.width * 2, height: rect.size.height * 2))
            let render = MAPolylineRenderer(overlay: overlay)
            render?.lineWidth = 8.0
//            render?.strokeColor = UIColor.blue
            render?.loadStrokeTextureImage(#imageLiteral(resourceName: "HomePage_path"))
            
//            self.mapView(mapView, didSelect: selectedView)
            stopWaitImageAnimate()
            return render
            
        }
        return nil
    }
    
    
    
    // MARK: - Pin view animate
    func pinViewAnimate() {
        let endFrame = pinView.frame
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -20)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
            self.pinView.frame = endFrame
        }, completion: nil)
    }
    
    // MARK: - Wait image animate
    func setWaitView() {
        waitView = UIView()
        waitImage = UIImageView(image: #imageLiteral(resourceName: "HUD_Group"))
        waitView.bounds.size.width = waitImage.bounds.size.width + 40
        waitView.bounds.size.height = waitView.bounds.size.width
        waitView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        waitView.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        waitImage.center = CGPoint(x: waitView.frame.width/2, y: waitView.frame.height/2)
        waitLabel = UILabel(frame: CGRect(x: 0, y: waitView.frame.height - 18, width: waitView.frame.width, height: 18))
        waitLabel.text = "正在计算路径"
        waitLabel.textColor = UIColor.white
        waitLabel.font = UIFont(name: "AlNile-Bold", size: 10)
        waitLabel.textAlignment = .center
        view.addSubview(waitView)
        waitView.addSubview(waitImage)
        waitView.addSubview(waitLabel)
        
        waitView.isHidden = true
    }
    func waitImageAnimate() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.isRemovedOnCompletion = false
        waitView.isHidden = false
        waitImage.layer.add(anim, forKey: nil)
    }
    
    func stopWaitImageAnimate() {
        waitImage.layer.removeAllAnimations()
        waitView.isHidden = true
    }
    
    // MARK : - Walk manager delegate
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        mapView.removeOverlays(mapView.overlays)
        var coordinates = walkManager.naviRoute!.routeCoordinates!.map {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        let ployline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        
        mapView.add(ployline)
        
        //计算时间和距离
        let walkMinute = walkManager.naviRoute!.routeTime / 60
        var timeDes = "1分钟以内"
        if walkMinute > 0 {
            timeDes = walkMinute.description + "分钟"
        }
        let title = "步行" + timeDes
        let subTitle = "距离" + walkManager.naviRoute!.routeLength.description + "米"
        
        selectedAnno.title = title
        selectedAnno.subtitle = subTitle
        
        selectedView.title = title
        selectedView.subtitle = subTitle
        
        mapView.addAnnotation(selectedAnno)
        
//        FTIndicator.setIndicatorStyle(.dark)
//        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: title, message: subTitle)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
