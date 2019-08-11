import Foundation
import WebKit

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    var state = String((0..<15).map{ _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
    
    @IBOutlet weak var loginWebView: WKWebView!
    private let clientId = "1df72c446808a58c0e92" // здесь должен быть ID вашего зарегистрированного приложения
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let request = tokenGetRequest else { return }
        loginWebView.load(request)
    }
    
    private var tokenGetRequest: URLRequest? {
        
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "state", value: state)
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                guard let url = URL(string: "https://github.com/login/oauth/access_token") else {return}
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let parameters: [String: Any] = [
                    "client_id": clientId,
                    "client_secret": "2b7c919f1d0a93c8b1f040e3b4516bc83ea0292e",
                    "code": code,
                    "state": state
                ]
                request.httpBody = parameters.percentEscaped().data(using: .utf8)

                URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {return}
                    let answer = String(data: data, encoding: .utf8)!
                    print("\(answer)")
                    guard let components = URLComponents(string: answer) else { return }
                    if let token = components.queryItems?.first(where: { $0.name == "code" })?.value {
                        self.delegate?.handleTokenChanged(token: token)
                    }
                }
            }
            dismiss(animated: true, completion: nil)
        }
        defer {
            decisionHandler(.allow)
        }
    }
}

private let scheme = "yanotes" // схема для callback

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
