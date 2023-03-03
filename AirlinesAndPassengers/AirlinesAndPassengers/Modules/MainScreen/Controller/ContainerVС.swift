//
//  ViewController.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 14.9.22.
//

import UIKit

class ContainerVС: UIViewController {
    
    // MARK: Constants -
    enum Constants {
        static let heightForSegmentController: CGFloat = 20
        static let topIndent: CGFloat = 0.05
        static let namesForSegment = ["", ""]
        static let BlackColor = #colorLiteral(red: 0.1599952579, green: 0.1600029767, blue: 0.1599760652, alpha: 1)
    }
    
    // MARK: private properties -
    private let segmentControl = UISegmentedControl(items: Constants.namesForSegment)
    private let scrollView = UIScrollView()
    
    private var airlinesViewController: UIViewController!
    private var passengersViewController: UIViewController!
    
    private lazy var airlinesNavigationVC = UINavigationController(rootViewController: airlinesViewController)
    private lazy var passengersNavigationVC = UINavigationController(rootViewController: passengersViewController)
    
    lazy private var pages = [airlinesNavigationVC.view, passengersNavigationVC.view]
    
    // MARK: life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BlackColor
        setScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        setSegmentControl()
    }
}

// MARK: private extension
private extension ContainerVС {
    // MARK: Segment Control -
    func setSegmentControl() {
        view.addSubview(segmentControl)
        
        segmentControl.frame = CGRect(x: 20, y: view.frame.height * Constants.topIndent, width: self.view.frame.width - 40, height: Constants.heightForSegmentController)
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = Constants.BlackColor
        
        // Panting text for picker label
//        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
//        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.BlackColor], for: UIControl.State.selected)
        segmentControl.addTarget(self, action: #selector(didTabSegment(_:)), for: .valueChanged)
    }
    
    @objc func didTabSegment(_ sender: UISegmentedControl) {
        goToPage(number: CGFloat(sender.selectedSegmentIndex))
    }
    
    func goToPage(number: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * number, y: 0), animated: true)
    }
    
    // MARK: Scroll View -
    func setScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = Constants.BlackColor
        
        let height = self.view.frame.height - ((view.frame.height * Constants.topIndent) + segmentControl.frame.height)
        let y = (self.view.frame.height * Constants.topIndent) + segmentControl.frame.height
        
        let frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
        scrollView.frame = frame
        scrollView.showsHorizontalScrollIndicator = false
        
        if scrollView.subviews.count == 0 {
            configureScrollView()
        }
    }
    
    // MARK: Create children screens -
    func configureScrollView() {
        let height = self.view.frame.height - (self.view.frame.height * Constants.topIndent) - segmentControl.frame.height
        let contentSize = CGSize(width: self.view.frame.size.width * 2, height: height)
        scrollView.contentSize = contentSize
        scrollView.isPagingEnabled = true
        
        self.airlinesViewController = AirlinesVC()
        self.passengersViewController = PassengersVC()
        
        for page in 0..<pages.count {
            
            if !scrollView.subviews.isEmpty && pages[page] != nil {
                let frame = CGRect(x: pages[page - 1]!.frame.maxX, y: 0, width: self.view.frame.size.width, height: height)
                pages[page]?.frame = frame
                scrollView.addSubview(pages[page]!)
                
            } else if pages[page] != nil {
                let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
                pages[page]?.frame = frame
                scrollView.addSubview(pages[page]!)
            }
        }
    }
}

// MARK: Scroll View Delegate -

extension ContainerVС: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newSegmentIndex = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        
        switch scrollView.contentOffset.x {
        case scrollView.frame.width * 0:
            segmentControl.selectedSegmentIndex = 0
        case scrollView.frame.width * 1:
            segmentControl.selectedSegmentIndex = 1
        default:
            break
        }
        
        switch newSegmentIndex {
        case  -1:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        case Constants.namesForSegment.count - 1:
            scrollView.setContentOffset(CGPoint(x: view.frame.size.width * 1, y: 0), animated: false)
        default:
            break
        }
    }
}
