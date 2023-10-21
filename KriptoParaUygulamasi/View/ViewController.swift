//
//  ViewController.swift
//  KriptoParaUygulamasi
//
//  Created by Atil Samancioglu on 21.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cryptoList = [Crypto]()
    let disposeBag = DisposeBag()
    
    let cryptoVM = CryptoViewModel()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        activity.isHidden = false
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CryptoCell.self, forCellReuseIdentifier: "cryptoCell")
        
        setupBindings()
        
        setLayouts()
        
        cryptoVM.requestData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let crypto = cryptoList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! CryptoCell
        cell.configureCell(with: crypto)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func setupBindings() {
        cryptoVM.cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        cryptoVM.error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        cryptoVM.loading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { isLoading in
                if isLoading {
                    print("Open Animated")
                    self.activityIndicator.startAnimating()
                } else {
                    print("Close Animated")
                    self.activityIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setLayouts() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
