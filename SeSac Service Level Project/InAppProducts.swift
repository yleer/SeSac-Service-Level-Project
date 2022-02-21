//
//  InAppProducts.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/20.
//

import Foundation
import StoreKit

extension Notification.Name {
  static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}


public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

open class IAPHelper: NSObject  {
    
    private let productIdentifiers: Set<String>
    private var purchasedProductIdentifiers: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    public var purchaseCompleteHandler: (() -> Void)?
 
    public init(productIds: Set<String>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
             print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
   }
}

extension IAPHelper {
  
    // 상품 정보 가져오기
  public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }
    

    public func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptUrl!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        guard let receiptString = receiptString, let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue)   else {
            print("not good String")
            return }
        
        ShopApiService.buyItem(idToken: idToken, receipt: receiptString, product: productIdentifier) { error, statusCode in
            if statusCode == 200 {
                print("success buyingitem")
                
                self.getMyShopInfo()
                
            }else if statusCode == 201 {
                print("유효하지 않은 receipt를 보낸 경우")
            }else {
                print("error with", error)
            }
        }
        

        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    private func getMyShopInfo() {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else {return }
        ShopApiService.getMyShopInfo(idToken: idToken) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(errorContent: let errorContent):
                    print("error" , errorContent)
                    self.getMyShopInfo()
                case .serverError(errorContent: let errorContent), .clientError(errorContent: let errorContent), .alreadyWithdrawl(errorContent: let errorContent):
                    print("error" , errorContent)
                }
            }else {
                print("success")
            }
        }
    }

    // 상품 구매하기
  public func buyProduct(_ product: SKProduct) {
      print(SKPaymentQueue.canMakePayments())
      print("Buying \(product.productIdentifier)...")
       let payment = SKPayment(product: product)
       SKPaymentQueue.default().add(payment)
      
      
      
  }

    // 구매한 상품인지 확인하기
  public func isProductPurchased(_ productIdentifier: String) -> Bool {
      return purchasedProductIdentifiers.contains(productIdentifier)  }
  
  public class func canMakePayments() -> Bool {
    return true
  }
  
  public func restorePurchases() {
  }
}


// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("Loaded list of products...")
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for p in products {
      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver
 
extension IAPHelper: SKPaymentTransactionObserver {
 
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("transactions")
    }
    
    // only required method:  It gets called when one or more transaction states change.
  public func paymentQueue(_ queue: SKPaymentQueue,
                           updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased:
          print("purchased in paymentquee")
          receiptValidation(transaction: transaction , productIdentifier: transaction.payment.productIdentifier)
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      default:
          break
      }
    }
  }
 
  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
 
    print("restore... \(productIdentifier)")
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
        transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(localizedDescription)")
      }

    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }
 
    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
  }
}


public struct RazeFaceProducts {

  public static let sesac1 = "com.memolease.sesac1.sprout1"
  public static let sesac2 = "com.memolease.sesac1.sprout2"
  public static let sesac3 = "com.memolease.sesac1.sprout3"
  public static let sesac4 = "com.memolease.sesac1.sprout4"
  
  private static let productIdentifiers: Set<String> = [
    RazeFaceProducts.sesac1,
    RazeFaceProducts.sesac2,
    RazeFaceProducts.sesac3,
    RazeFaceProducts.sesac4
  ]

  public static let store = IAPHelper(productIds: RazeFaceProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
