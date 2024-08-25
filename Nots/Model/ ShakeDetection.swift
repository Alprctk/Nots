//
//   ShakeDetection.swift
//  Nots
//
//  Created by Alper Çatak on 16.07.2024.
//

import UIKit

extension UIDevice {
    static let shakeNotification = Notification.Name("UIDeviceShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.shakeNotification, object: nil)
        }
    }
}
