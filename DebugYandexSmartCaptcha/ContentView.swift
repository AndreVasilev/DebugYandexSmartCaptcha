//
//  ContentView.swift
//  DebugYandexSmartCaptcha
//
//  Created by Andrey Vasilev on 22.12.2023.
//

import SwiftUI

func captcahUrl(invisible: Bool) -> URL? {
    assert(!mobileCaptchaHtmlPath.isEmpty, "mobileCaptchaHtmlPath not set")
    let link = mobileCaptchaHtmlPath + "/mobile-captcha.html?invisible=\(invisible ? "true" : "false")&hideShield=true"
    return URL(string: link)
}

struct ContentView: View {

    @State var isInvisible: Bool = false
    @State var url: URL?
    @State var token: String?

    var body: some View {
        VStack {
            HStack {
                Button("Visible") {
                    url = captcahUrl(invisible: false)
                    token = nil
                }
                Spacer()
                Button("Invisible") {
                    url = captcahUrl(invisible: true)
                    token = nil
                }
                Spacer()
                Button("Reset") {
                    url = nil
                    token = nil
                }
            }
            if let url {
                WebView(
                    configuration: .captcha(
                        onSuccess: { token in
                            debugPrint("Captcha succeed: \(token ?? "nil")")
                            self.token = token
                        },
                        onCancel: {
                            debugPrint("Captcha cancelled")
                        }
                    ),
                    url: url
                )
                .inspectable(mode: .debug)
                .background(Color.gray)
            }
            if let token {
                Text(token)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
