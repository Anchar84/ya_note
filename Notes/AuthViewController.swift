import Foundation
import WebKit

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet weak var loginWebView: WKWebView!
    private let clientId = "1df72c446808a58c0e92" // здесь должен быть ID вашего зарегистрированного приложения
    private let client = "1df72c446808a58c0e92" // здесь должен быть ID вашего зарегистрированного приложения
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginWebView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let request = tokenGetRequest else { return }
        loginWebView.load(request)
//        loginWebView.navigationDelegate = self
    }
    
    private var tokenGetRequest: URLRequest? {
        
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "scope", value: "gist")
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\(navigationAction.request.url?.absoluteString)")
//        if let url = navigationAction.request.url, url.scheme == scheme {
//            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
//            guard let components = URLComponents(string: targetString) else { return }
//
//            if let token = components.queryItems?.first(where: { $0.name == "code" })?.value {
//
//                delegate?.handleTokenChanged(token: token)
//            }
//            dismiss(animated: true, completion: nil)
//        }
        defer {
            decisionHandler(.allow)
        }
    }
}

private let scheme = "yanotes" // схема для callback
