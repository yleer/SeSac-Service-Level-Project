//
//  InAppProducts.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/20.
//

import Foundation
import StoreKit

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

open class IAPHelper: NSObject  {
 
   public init(productIds: Set<String>) {
     productIdentifiers = productIds
   super.init()
 }
 
 private let productIdentifiers: Set<String>
 private var purchasedProductIdentifiers: Set<String> = []
 private var productsRequest: SKProductsRequest?
 private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
}

extension IAPHelper {
  
  public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct) {
  }

  public func isProductPurchased(_ productIdentifier: String) -> Bool {
    return false
  }
  
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
