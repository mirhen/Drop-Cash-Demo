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

struct Constants {
    
    struct Stripe {
        static let publishableKey = "pk_test_e2d78N2Mi0tI6BmDCtIIT5pP"
        static let baseURLString = "https://kinder-smarties-23688.herokuapp.com"
        static let defaultCurrency = "usd"
        static let defaultDescription = "Purchase from Test Connect"
    }
    
    struct Segue {
        static let toWelcomeUser = "toWelcomeUser"
        static let toRegisterBeacon = "toRegisterBeacon"
        static let exitToController = "exitToController"
        static let toAmountController = "toAmountController"
    }
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let bId = "bId"
        static let stripeAccount = "stripeAccount"
        static let canReceive = "canReceive"
        static let username = "username"
    }
    struct Firebase {
        static let serverKey = "AAAAwlRmkkE:APA91bFnW2x58LS6XX6nlokzuNv5cP4gTFbSgAv13Am6JX7d8QrJXBeGYT4kZTJ4us04-ryuY1QG7jHyc5zHRh4qGR1_-OSVKgo1nx81FX9n5nJquUE9mneuOKuWWGgIILlcM-OmlXqD"
    }
    struct EstimoteCloud {
        static let appID = "miriamhaart-gmail-com-s-pr-dyg"
        static let appToken = "f9d1d993b1baaf8b09e3d13d91459623"
    }
}
