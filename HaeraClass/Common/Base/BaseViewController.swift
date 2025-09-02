//
//  BaseViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

class BaseViewController: UIViewController {

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
