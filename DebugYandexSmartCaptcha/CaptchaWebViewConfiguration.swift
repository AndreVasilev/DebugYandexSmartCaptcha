//
//  CaptchaWebViewConfiguration.swift
//
//  Created by Andrey Vasilev on 06.09.2023.
//

import Foundation
import WebKit

extension WKWebViewConfiguration {

    static func captcha(onSuccess: @escaping (String?) -> Void, onChallenge: @escaping () -> Void = {}, onCancel: @escaping () -> Void) -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let handler = CaptchaMessageHandler(onSuccess: onSuccess, onChallenge: onChallenge, onCancel: onCancel)
        configuration.userContentController.add(handler, name: "NativeClient")
        return configuration
    }

    static var debugCaptcha: WKWebViewConfiguration {
        return .captcha(
            onSuccess: {
                debugPrint("captchaDidFinish: \($0 ?? "nil")")
            },
            onChallenge: {
                debugPrint("challengeDidAppear")
            },
            onCancel: {
                debugPrint("challengeDidDisappear")
            })
    }
}

class CaptchaMessageHandler: NSObject, WKScriptMessageHandler {

    let onSuccess: (String?) -> Void
    let onChallenge: () -> Void
    let onCancel: () -> Void

    init(onSuccess: @escaping (String?) -> Void, onChallenge: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onSuccess = onSuccess
        self.onChallenge = onChallenge
        self.onCancel = onCancel
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let jsData = message.body as? [String: String] else { return }

        switch jsData["method"] {
        case "captchaDidFinish": onSuccess(jsData["data"])
        case "challengeDidAppear": onChallenge()
        case "challengeDidDisappear": onCancel()
        default: return
        }
    }
}
