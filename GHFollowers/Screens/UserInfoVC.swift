//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 7/13/24.
//

import UIKit


protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController {
    
    let scrollView            = UIScrollView()
    let contentView           = UIView()

    let headerView            = UIView()
    let itemViewOne           = UIView()
    let itemViewTwo           = UIView()
    let dateLabel             = GFBodyLabel(textAlignment: .center)

    var itemViews  : [UIView] = []
    
    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func getUserInfo() {
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            }
            catch {
                if let gfError = error as? GFError  {
                    presentGFAlert(title: "Something went wrong" , message: gfError.rawValue, buttonTitle: "OK")
                }
                else {
                     presentDefaultAlert()
                }
            }
        }
    }

    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    
    func configureUIElements(with user: User){
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "Github Since \(user.createdAt.convertToDisplayFormat())"
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }

        
            
 
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC () {
        dismiss(animated: true)
    }
}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL (string: user.htmlUrl) else {
            presentGFAlert(title: "Invalid URL", message: "The url attached to this user is invalied", buttonTitle: "OK")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoVC:GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(title: "No follower", message: "This user has no followers", buttonTitle: "OK")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

//extension UserInfoVC: ItemInfoVCDelegate {
//    func didTapGitHubProfile(for user: User) {
//        guard let url = URL (string: user.htmlUrl) else {
//            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalied", buttonTitle: "OK")
//            return
//        }
//        presentSafariVC(with: url)
//    }
//    
//    func didTapGetFollowers(for user: User) {
//        guard user.followers != 0 else {
//            presentGFAlertOnMainThread(title: "No follower", message: "This user has no followers", buttonTitle: "OK")
//            return
//        }
//        delegate.didRequestFollowers(for: user.login)
//        dismissVC()
//    }
//    
//    
//}
