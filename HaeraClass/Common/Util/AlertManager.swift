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

    func showLogoutAlert(_ title: String, logoutHandler: (() -> Void)?) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        guard let rootVC = sceneDelegate.window?.rootViewController else { return }

        let alert = UIAlertController(title: "확인", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { _ in
            UserDefaults.standard.removeObject(forKey: "token")
            logoutHandler?()
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

    func makeActionSheet(reviseHandler: (() -> Void)?, deleteHanlder: (() -> Void)?) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        guard let rootVC = sceneDelegate.window?.rootViewController else { return }

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reviseAction = UIAlertAction(title: "댓글 수정", style: .default) { _ in
            reviseHandler?()
        }
        let deleteAction = UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
            deleteHanlder?()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        actionSheet.addAction(reviseAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)

        rootVC.present(actionSheet, animated: true)
    }
}
