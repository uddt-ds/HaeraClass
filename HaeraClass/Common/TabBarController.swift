//
//  TabBarController.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import UIKit

final class TabBarController: UITabBarController {

    private var firstVC = ClassCheckViewController()
    private var secondVC = ClassSearchViewController()
    private var thirdVC = ViewController()    // TODO: settingVC로 변경

    private lazy var firstNav = UINavigationController(rootViewController: firstVC)
    private lazy var secondNav = UINavigationController(rootViewController: secondVC)
    private lazy var thirdNav = UINavigationController(rootViewController: thirdVC)

    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBarUI()
        setupTabBar()
        setupNavTitle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupTabBarUI() {
        self.tabBar.tintColor = .darkGray
    }

    private func setupTabBar() {
        firstNav.tabBarItem = UITabBarItem(title: TabBarMenu.category.title,
                                           image: ImageSet.house.image,
                                           tag: TabBarMenu.category.rawValue)
        secondNav.tabBarItem = UITabBarItem(title: TabBarMenu.search.title,
                                            image: ImageSet.magnifyingglass.image,
                                            tag: TabBarMenu.search.rawValue)
        thirdNav.tabBarItem = UITabBarItem(title: TabBarMenu.setting.title,
                                          image: ImageSet.person.image,
                                          tag: TabBarMenu.setting.rawValue)

        viewControllers = [firstNav, secondNav, thirdNav]
    }

    private func setupNavTitle() {
        self.tabBar.backgroundColor = .white
        
        let firstLabel = configureNavLabel(TabBarMenu.category.navTitle)
        firstNav.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: firstLabel)

        let secondLabel = configureNavLabel(TabBarMenu.search.navTitle)
        secondNav.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: secondLabel)

        let thirdLabel = configureNavLabel(TabBarMenu.setting.navTitle)
        thirdNav.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: thirdLabel)
    }

    private func configureNavLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }
}

extension TabBarController {
    enum TabBarMenu: Int {
        case category
        case search
        case setting

        var title: String {
            switch self {
            case .category: return "카테고리"
            case .search: return "검색"
            case .setting: return "설정"
            }
        }

        var navTitle: String {
            switch self {
            case .category: return "클래스 조회"
            case .search: return "클래스 검색"
            case .setting: return "프로필"
            }
        }
    }
}
