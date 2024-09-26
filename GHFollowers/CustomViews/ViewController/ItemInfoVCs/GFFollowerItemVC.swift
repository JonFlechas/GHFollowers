//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 8/6/24.
//

import Foundation

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    
    init(user: User, delegate:GFFollowerItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        ItemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        ItemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(color: .systemGreen , title: "Get Followers", systemImageName: "person.3")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
