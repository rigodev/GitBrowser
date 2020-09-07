//
//  UserRepoCell.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import RxGesture
import RxSwift
import SnapKit
import UIKit

final class UserRepoCell: UITableViewCell {
    private let contentContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    fileprivate let descriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Description", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 2
        return button
    }()
    
    private let descriptionContainer = UIView()
    
    private let updatedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
    private func prepareCell() {
        contentView.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentContainer.addArrangedSubview(nameLabel)
        contentContainer.addArrangedSubview(languageLabel)
        contentContainer.addArrangedSubview(descriptionButton)
        contentContainer.addArrangedSubview(descriptionContainer)

        descriptionContainer.addSubview(updatedLabel)
        updatedLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        descriptionContainer.addSubview(starsLabel)
        starsLabel.snp.makeConstraints { make in
            make.top.equalTo(updatedLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func update(with model: UserRepo) {
        nameLabel.text = model.name
        languageLabel.text = model.language
        
        descriptionButton.isHidden = model.shouldShowDescription
        descriptionContainer.isHidden = !model.shouldShowDescription
        
        updatedLabel.text = model.updated
        starsLabel.text = model.starsCount
    }
    
}

extension Reactive where Base == UserRepoCell {
    var descriptionTap: Observable<Void> {
        base.descriptionButton.rx.tap.asObservable()
    }
}
