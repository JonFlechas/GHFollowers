//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 8/6/24.
//

import Foundation


protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user: User, delegate:GFRepoItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems() {
        ItemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        ItemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemImageName: "person")

    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
