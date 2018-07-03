/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Alamofire
import Stripe
import Firebase

enum Result {
  case success
  case failure(Error)
}

final class StripeClient {
  
  static let shared = StripeClient()
  
  private init() {
    // private
  }
  
  private lazy var baseURL: URL = {
    guard let url = URL(string: Constants.Stripe.baseURLString) else {
      fatalError("Invalid URL")
    }
    return url
  }()
  
    
    func completeCharge(with token: STPToken, user: User, payment: Payment, completion: @escaping (Result) -> Void) {
        // 1

        let url = baseURL.appendingPathComponent("api/stripe/charge")
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": payment.amount,
            "currency": Constants.Stripe.defaultCurrency,
            "description": payment.description ?? Constants.Stripe.defaultDescription,
            "stripe_account_id": user.stripeAccount!.id,
            "stripe_account_private_key": user.stripeAccount!.privKey
        ]
        print("posting to charge api")
        // 3
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                    print("charge complete")
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
    func connectStripeAccount(authToken: String) {
        let url = URL(string: "https://connect.stripe.com/oauth/token")!
        let params = ["client_secret": "sk_test_CGDb5KJQsfFa6D30mIwTC7r9",
                      "code": authToken,
                      "grant_type":"authorization_code"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value {
                if let jsonDict = json as? [String: Any] {
                    
                    guard let pubKey = jsonDict["stripe_publishable_key"] as? String,
                       let privKey = jsonDict["access_token"] as? String,
                        let userId = jsonDict["stripe_user_id"] as? String else {
                            return
                    }
                    
                    let stripeAccount = StripeAccount(id: userId, pubKey: pubKey, privKey: privKey)
                    UserService.addStripeAccountTo(User.current, stripeAccount: stripeAccount, completion: { (user) in
                        if let user = user {
                            User.setCurrent(user)
                        }
                    })
                    
                    
                }
            }
        }
    }
    
    func createStripeAccount(user: FIRUser, completion: @escaping (String?) -> ()) {
        let firstName = String(user.displayName!.split(separator: " ")[0])
        let lastName = String(user.displayName!.split(separator: " ")[1])
        print(user.email!)
        let url = baseURL.appendingPathComponent("api/stripe/account/setup")
        let params = ["email": user.email!,
                      "first_name": firstName,
                      "last_name": lastName]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value {
                if let jsonDict = json as? [String: Any] {
            
                    let accountId = jsonDict["accountId"] as! String
                    
                    print("Stripe Account ID: ", accountId)
                    completion(accountId)
                }
            }
        }
        
    }
    
    func signInToConnectWithUser(_ user: User) {
        UIApplication.shared.open(URL(string : "https://dashboard.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_D5KCNPYIinBW1CDgwiugqADu4rvTYvWE&state=\(user.uid)")!, options: [:], completionHandler: { (status) in
            print("sending to safari ")
        })
    }
    
    
    func testServer() {
        let url = URL(string: "https://kinder-smarties-23688.herokuapp.com/test")
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value {
                if let jsonDict = json as? [String: Any] {
                    print(jsonDict["success"] as? String)
                }
            }
        }
    }
}
