//
//  UserInfoView.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class UserInfoView: UIView {
    private let horizontalContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.spacing = 20
        return stack
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let verticalContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private func makeInfoLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = text
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
    private func setup() {
        addSubview(horizontalContainer)
        horizontalContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        horizontalContainer.addArrangedSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(iconView.snp.width)
        }
        
        horizontalContainer.addArrangedSubview(verticalContainer)
    }
    
    fileprivate func update(with model: UserInfo) {
        if let encodingUrlString = model.avatarPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let iconUrl = URL(string: encodingUrlString) {
            iconView.kf.setImage(with: iconUrl, options: [.cacheOriginalImage])
        }
        
        if let name = model.name {
            verticalContainer.addArrangedSubview(makeInfoLabel(with: name))
        }
        
        verticalContainer.addArrangedSubview(makeInfoLabel(with: model.login))
        verticalContainer.addArrangedSubview(makeInfoLabel(with: model.created))
        
        if let location = model.location {
            verticalContainer.addArrangedSubview(makeInfoLabel(with: location))
        }
    }
    
}

extension Reactive where Base == UserInfoView {
    var info: Binder<UserInfo> {
        Binder(base) { (base: Base, info: UserInfo) in
            base.update(with: info)
        }
    }
}
