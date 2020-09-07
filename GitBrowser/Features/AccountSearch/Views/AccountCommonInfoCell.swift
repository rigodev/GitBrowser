//
//  AccountCommonInfoCell.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Kingfisher
import RxGesture
import RxSwift
import SnapKit
import UIKit

final class AccountCommonInfoCell: UITableViewCell {
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
    
    private let verticalContainer = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
    private func prepareCell() {
        contentView.addSubview(horizontalContainer)
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
        
        verticalContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        verticalContainer.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func update(with model: AccountCommonInfo) {
        titleLabel.text = model.login
        subtitleLabel.text = model.type.description
        
        if let encodingUrlString = model.avatarPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let iconUrl = URL(string: encodingUrlString) {
            iconView.kf.setImage(with: iconUrl, options: [.cacheOriginalImage])
        }
    }
    
}

extension Reactive where Base == AccountCommonInfoCell {
    var tap: Observable<Void> {
        base.contentView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
    }
}
