//
//  UnwrappableNetworkResponse.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation
protocol UnwrappableNetworkResponse {
    func unwrapResult<T>(_ result: Results<T>, with errorNotificationName: Notification.Name?) -> T?
}

extension UnwrappableNetworkResponse {
    
    func unwrapResult<T>(_ result: Results<T>, with errorNotificationName: Notification.Name? = nil) -> T? {
        guard let resultValue = result.value else {
            if let errorNotificationName = errorNotificationName {
                var userInfo: [AnyHashable: Any] = [:]
                
                if let errorDescription = result.error?.localizedDescription {
                    userInfo[Notification.Key.ErrorDescription] = errorDescription
                }
                
                if let errorDescription = (result.error as? ResponseError)?.errorDescription {
                    userInfo[Notification.Key.ErrorDescription] = errorDescription
                }
                
                if let statusCode = (result.error as? ResponseError)?.statusCode {
                    userInfo[Notification.Key.ErrorStatusCode] = statusCode
                }
                
                postMainQueueNotification(name: errorNotificationName, userInfo: userInfo)
            }
            return nil
        }
        return resultValue
    }
}

// Closure
typealias VoidClosure = (() -> Void)
typealias ClosureWith<T> = (T) -> Void

// NotificationCentre
func postMainQueueNotification(name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
    let postNotificationBlock = {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    if Thread.isMainThread {
        postNotificationBlock()
    } else {
        DispatchQueue.main.async { postNotificationBlock() }
    }
}
