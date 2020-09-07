//
//  AccountSearchViewController.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol AccountSearchViewControllerDelegate: AnyObject {
    func showAccountDetail(with login: String)
}

final class AccountSearchViewController: UIViewController {
    weak var delegate: AccountSearchViewControllerDelegate?
    
    private let viewModel: AccountSearchViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var accountsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.prefetchDataSource = self
        table.register(forType: AccountCommonInfoCell.self)
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "account name"
        return bar
    }()
    
    private let sortContainer: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.alignment = .center
        return view
    }()
    
    private let sortingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Sorting by account"
        return label
    }()
    
    private let sortSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        return switcher
    }()
    
    init(viewModel: AccountSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigation()
        prepareView()
        makeConstraints()
        bind()
    }
    
    private func prepareNavigation() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func prepareView() {
        title = "Account searching"
        view.backgroundColor = ColorTheme.backgroundColor
        
        view.addSubview(searchBar)
        view.addSubview(sortContainer)
        sortContainer.addArrangedSubview(sortingLabel)
        sortContainer.addArrangedSubview(sortSwitcher)
        view.addSubview(accountsTableView)
    }
    
    private func bind() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { .getAccounts(name: $0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        sortSwitcher.rx.isOn
            .distinctUntilChanged()
            .map { AccountSearchViewModel.Action.sortingIsOnChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.accounts }
            .distinctUntilChanged()
            .bind(to: accountsTableView.rx.items) ({ [unowned self] (tableView: UITableView, index: Int, element: AccountCommonInfo) in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.accountsTableView.dequeueReusableCell(AccountCommonInfoCell.self, for: indexPath)
                cell.update(with: element)
                cell.rx.tap
                    .map { element }
                    .subscribe(onNext: { element in
                        self.delegate?.showAccountDetail(with: element.login)
                    }).disposed(by: cell.rx.reuseBag)
                return cell
            }).disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.isActivityIndicatorRunning)
            .disposed(by: disposeBag)
    }
    
    private func makeConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        sortContainer.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        sortSwitcher.setContentHuggingPriority(.required, for: .horizontal)
        
        accountsTableView.snp.makeConstraints { make in
            make.top.equalTo(sortContainer.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension AccountSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row == viewModel.currentState.accounts.count - 1 }) {
            viewModel.action.onNext(.getNextAccounts)
        }
    }
}
