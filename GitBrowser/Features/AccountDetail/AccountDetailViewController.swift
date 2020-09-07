//
//  AccountDetailViewController.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AccountDetailViewController: UIViewController {
    private let viewModel: AccountDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let infoView = UserInfoView()
    
    private lazy var reposTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.register(forType: UserRepoCell.self)
        table.delegate = self
        return table
    }()
    
    init(viewModel: AccountDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        makeConstraints()
        bind()
        
        viewModel.action.onNext(.getUser)
    }
    
    private func prepareView() {
        title = "Account detail"
        view.backgroundColor = ColorTheme.backgroundColor
        
        view.addSubview(infoView)
        view.addSubview(reposTableView)
    }
    
    private func bind() {
        viewModel.state
            .map { $0.userInfo }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: infoView.rx.info)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.repos }
            .distinctUntilChanged()
            .bind(to: reposTableView.rx.items) ({ [unowned self] (tableView: UITableView, index: Int, element: UserRepo) in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.reposTableView.dequeueReusableCell(UserRepoCell.self, for: indexPath)
                cell.update(with: element)
                cell.rx.descriptionTap
                    .map { AccountDetailViewModel.Action.descriptionTap(index: index) }
                    .bind(to: self.viewModel.action)
                    .disposed(by: cell.rx.reuseBag)
                return cell
            }).disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.isActivityIndicatorRunning)
            .disposed(by: disposeBag)
    }
    
    private func makeConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        reposTableView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension AccountDetailViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
