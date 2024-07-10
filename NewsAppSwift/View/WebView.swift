//
//  WebView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import SwiftUI
import WebKit

struct WebView: View {
    var body: some View {
        VStack {
            WebViewRepresentable(url: "https://github.com/parth1009/openssl-apple/releases")
        }
    }
}

#Preview {
    WebView()
}

struct WebViewRepresentable: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: UIDevice.screenHeight))
        webView.load(URLRequest(url: URL(string: url)!))
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            AppPrint.debugPrint("didFail: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            AppPrint.debugPrint("didFailProvisionalNavigation: \(error.localizedDescription)")
        }
    }
}
