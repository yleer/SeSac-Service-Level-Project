//
//  ChattingViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/29.
//

import Foundation
import UIKit

class ChattingViewController: UIViewController {
    
    let mainView = ChatView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title =
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: ImageNames.ChatViewController.more), style: .plain, target: self, action: #selector(showExtraButtonClicked))
        
        addTargets()
    }
    
    func addTargets() {
        mainView.reportButton.addTarget(self, action: #selector(reportButtonClicked), for: .touchUpInside)
        mainView.cancelButton.addTarget(self, action: #selector(cancelButtonnClicked), for: .touchUpInside)
        mainView.reviewButton.addTarget(self, action: #selector(reviewButtonClicked), for: .touchUpInside)
    }
    
    @objc func reportButtonClicked() {
        let vc = ChatMenuViewController()
        vc.menuType = .report
        vc.mainView.title.text = "새싹 신고"
        vc.mainView.subTitle.text = "다시는 해당 새싹과 매칭되지 않습니다"
        vc.mainView.textView.text = "kiki"
        vc.mainView.confirmButton.setTitle("신고하기", for: .normal)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func cancelButtonnClicked() {
        let vc = DeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.mainView.title.text = "약속을 취소하시겠습니까?"
        vc.mainView.subTitle.text = "약속을 취소하면 패널티가 부과됩니다"
        self.present(vc, animated: true, completion: nil)
    }
    @objc func reviewButtonClicked() {
        let vc = ChatMenuViewController()
        vc.menuType = .review
        vc.mainView.title.text = "리뷰 등록"
        vc.mainView.subTitle.text = "고래밥님과의 취미 활동은 어떠셨나요?"
        vc.mainView.textView.text = "kiki"
        vc.mainView.confirmButton.setTitle("gh", for: .normal)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func showExtraButtonClicked() {
        self.mainView.moreView.isHidden = self.mainView.moreView.isHidden ? false : true
    }
}
