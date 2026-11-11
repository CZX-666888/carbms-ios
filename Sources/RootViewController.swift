import UIKit
import WebKit

/// 车主端 iOS 外壳：直接加载 H5 车主端，登录后即可查看设备参数与下发控制指令。
/// 服务地址 https://chezhi.xin 已在小程序/公众号侧通用，iOS 侧同样走它。
class RootViewController: UIViewController, WKNavigationDelegate {

    private let entry = "https://chezhi.xin/h5/"
    private var webView: WKWebView!
    private var progress: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "随车电源"
        view.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.12, alpha: 1)

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = view.backgroundColor
        webView.scrollView.backgroundColor = view.backgroundColor
        view.addSubview(webView)

        progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = UIColor(red: 0.20, green: 0.55, blue: 0.98, alpha: 1)
        view.addSubview(progress)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progress.topAnchor.constraint(equalTo: webView.topAnchor),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progress.heightAnchor.constraint(equalToConstant: 2)
        ])

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        if let url = URL(string: entry) {
            webView.load(URLRequest(url: url))
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let p = Float(webView.estimatedProgress)
            progress.progress = p
            progress.isHidden = p >= 1.0
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progress.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progress.isHidden = true
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}
