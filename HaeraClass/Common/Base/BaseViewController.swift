//
//  BaseViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

class BaseViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }

    func configureHierarchy() {

    }

    func configureLayout() {

    }

    func configureView() {
        view.backgroundColor = .white
    }

}
