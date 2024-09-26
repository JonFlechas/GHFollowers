//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 6/8/24.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    
    let tableView             = UITableView()
    var favorites: [Follower] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    // you use this one in case of an edge case where the user had no favorites and empty state is presented. If the user then added a favorite then the empty state would still be up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title                = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
  
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame      = view.bounds
        tableView.rowHeight  = 80
        tableView.removeExcessCells()
        
        tableView.delegate   = self
        tableView.dataSource = self

        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let favorites):
                updateUI(with: favorites)
            case.failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")

                }
                
            }
        }
    }
    
    
    func updateUI(with favorites: [Follower]){
        if favorites .isEmpty {
            self.showEmptyStateView(with: "No favorites?\n Add one on the follower screen", in: self.view)
        }
        else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}


extension FavoritesListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC   = FollowerListVC(username: favorite.login)
        
        //push is when you're putting on display a new screen; presenting is when youre doing modally
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return }
        
        let favorite = favorites[indexPath.row]
        

        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self else {return}
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\n Add one on the follower screen", in: self.view)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to unfavorite", message: error.rawValue, buttonTitle: "OK")

            }
        }

    }
}
