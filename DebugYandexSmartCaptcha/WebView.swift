//
//  WebView.swift
//
//  Created by Andrey Vasilev on 06.09.2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    enum InspectableMode {
        case always, debug, none
    }

    let configuration: WKWebViewConfiguration?
    var url: URL?
    private var isUrlEditable: Bool
    var inspectableMode: InspectableMode

    init(
        configuration: WKWebViewConfiguration? = nil,
        url: URL? = nil,
        inspectableMode: WebView.InspectableMode = .none
    ) {
        self.configuration = configuration
        self.url = url
        self.isUrlEditable = url == nil
        self.inspectableMode = inspectableMode
    }

    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let view: WKWebView
        if let configuration {
            view = WKWebView(frame: .zero, configuration: configuration)
        } else {
            view = WKWebView()
        }
        view.isOpaque = false
        view.setInspectable(inspectableMode)
        if let url {
            let request = URLRequest(url: url)
            view.load(request)
        }
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        uiView.setInspectable(inspectableMode)
        if isUrlEditable,
           let url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

fileprivate extension WKWebView {

    func setInspectable(_ mode: WebView.InspectableMode) {
        if #available(iOS 16.4, *) {
            switch mode {
            case .always:
                isInspectable = true
            case .debug:
                #if DEBUG
                isInspectable = true
                #else
                isInspectable = false
                #endif
            case .none:
                isInspectable = true
            }
        }
    }
}

// MARK: - Modifiers

extension WebView {

    func inspectable(mode value: InspectableMode) -> Self {
        var view = self
        view.inspectableMode = value
        return view
    }

    func url(string value: String) -> Self {
        var view = self
        view.url = URL(string: value)
        return view
    }
}
