//
//  OnBoardingView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/23.
//

import UIKit
import SnapKit

class OnBoardingView: UIView {
    
    let scrollView = UIScrollView()
    let startButton = InActiveButton()
    let pageControl = UIPageControl()
    
    
    let titleLabel = UILabel()
    let onBoardingImage = UIImageView()
    
    let titleLabel2 = UILabel()
    let onBoardingImage2 = UIImageView()
    
    
    let titleLabel3 = UILabel()
    let onBoardingImage3 = UIImageView()
    
    
    var titles: [UILabel] = []
    var images: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        setUpConstraints()
        configureScrollView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(startButton)
        
        backgroundColor = .white
        
        onBoardingImage.image = UIImage(named: "onboarding_img1")
        startButton.setTitle("시작하기", for: .normal)
        startButton.stateOfButton = .fill
        
        
        onBoardingImage2.image = UIImage(named: "onboarding_img2")
        onBoardingImage3.image = UIImage(named: "Social life-cuate")
        
        titles = [titleLabel, titleLabel2, titleLabel3]
        images = [onBoardingImage, onBoardingImage2, onBoardingImage3]
        
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let attributedStr = NSMutableAttributedString(string: "위치 기반으로 빠르게 주위 친구를 확인")
        attributedStr.addAttribute(.foregroundColor, value: UIColor(named: "brand colorgreen")!, range: ("위치 기반으로 빠르게 주위 친구를 확인" as NSString).range(of: "위치 기반"))
    
        attributedStr.addAttribute(.font, value: UIFont(name: "NotoSansKR-Medium", size: 24)!, range: ("위치 기반으로 빠르게 주위 친구를 확인" as NSString).range(of: "위치 기반으로 빠르게 주위 친구를 확인"))
        
    
        let attributedStr2 = NSMutableAttributedString(string: "관심사가 같은 친구를 찾을 수 있어요")
        attributedStr2.addAttribute(.foregroundColor, value: UIColor(named: "brand colorgreen")!, range: ("관심사가 같은 친구를 찾을 수 있어요" as NSString).range(of: "관심사가 같은 친구"))
        attributedStr2.addAttribute(.font, value: UIFont(name: "NotoSansKR-Medium", size: 24)!, range: ("관심사가 같은 친구를 찾을 수 있어요" as NSString).range(of: "관심사가 같은 친구를 찾을 수 있어요"))
        
        
        let attributedStr3 = NSMutableAttributedString(string: "SeSAC Friends")
        attributedStr3.addAttribute(.font, value: UIFont(name: "NotoSansKR-Medium", size: 24)!, range: ("SeSAC Friends" as NSString).range(of: "SeSAC Friends"))
        
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedStr
        
        titleLabel2.textAlignment = .center
        titleLabel2.numberOfLines = 0
        titleLabel2.attributedText = attributedStr2
        
        
        titleLabel3.textAlignment = .center
        titleLabel3.numberOfLines = 0
        titleLabel3.attributedText = attributedStr3
        
    
        pageControl.numberOfPages = 3
        pageControl.backgroundStyle = .minimal

        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        
        onBoardingImage.contentMode = .scaleAspectFill
    }
    
    func setUpConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide)
//            make.bottom.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }

        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-42)
            make.centerX.equalTo(startButton.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(8)
            make.top.equalTo(scrollView.snp.bottom).offset(56)
        }
        
    }
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for x in 0..<3 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * self.frame.size.width, y: 0, width: self.frame.width, height: self.frame.height))
            
            page.addSubview(titles[x])
            page.addSubview(images[x])
            
            titles[x].snp.makeConstraints { make in
                make.top.equalTo(page.snp.top).offset(78)
                make.leading.equalTo(page.snp.leading).offset(85)
                make.trailing.equalTo(page.snp.trailing).offset(-85)
                make.height.equalTo(76)
            }
            
            images[x].snp.makeConstraints { make in
                make.top.equalTo(titles[x].snp.bottom).offset(56)
                make.leading.equalToSuperview().offset(85)
                make.trailing.equalToSuperview().offset(-85)
                make.height.equalTo(images[x].snp.width)
            }
            
            scrollView.addSubview(page)
        }
//        scrollView.addSubview(vi)
    }
    
}
