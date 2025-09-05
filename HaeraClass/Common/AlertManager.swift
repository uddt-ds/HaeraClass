//
//  AlertManager.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()

    private init() { }

    func showLogoutAlert(_ title: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        guard let rootVC = sceneDelegate.window?.rootViewController else { return }

        let alert = UIAlertController(title: "확인", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { _ in
            //여기서 데이터 삭제
            print("눌렸습니다")
        }
        let noAction = UIAlertAction(title: "아니요", style: .default)
        alert.addAction(okAction)
        alert.addAction(noAction)

        rootVC.present(alert, animated: true)
    }

    func showBasicAlert(_ title: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        guard let rootVC = sceneDelegate.window?.rootViewController else { return }

        let alert = UIAlertController(title: "확인", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)

        rootVC.present(alert, animated: true)
    }
}
