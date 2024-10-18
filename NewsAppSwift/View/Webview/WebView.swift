//
//  WebView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import SafariServices
import SwiftUI
import WebKit

struct WebView: View {
    var url: String
    @State var isLoading: Bool = false
    var body: some View {
        VStack {
            WebViewRepresentable(url: url, isLoading: $isLoading)
                .onAppear {
                    //                    isLoading = true
                }
        }
        .loader(loading: isLoading)
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    var url: String
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(
            frame: CGRect(
                x: 0, y: 0, width: UIDevice.screenWidth,
                height: UIDevice.screenHeight))
        webView.load(URLRequest(url: URL(string: url)!))
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_: UIViewType, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(_: WKWebView, didFail _: WKNavigation!, withError error: any Error) {
            parent.isLoading = false
            AppPrint.debugPrint("didFail: \(error.localizedDescription)")
        }

        func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: any Error) {
            parent.isLoading = false
            AppPrint.debugPrint(
                "didFailProvisionalNavigation: \(error.localizedDescription)")
        }

        func webView(_: WKWebView, didFinish _: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context _: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _: SFSafariViewController,
        context _: UIViewControllerRepresentableContext<SafariView>
    ) {}
}
