//
//  MainViewController.swift
//  ARTheatre
//
//  Created by Владислав Ковальский on 15.02.2023.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать\n в AR-кинотеатр!"
        label.font = .systemFont(ofSize: 35, weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var mainSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте видео из вашей галереи, чтобы посмотреть его в AR."
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить видео", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addVideoButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainBg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie"]
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        mainButton.applyGradient(with: [#colorLiteral(red: 0, green: 0.1134020612, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.9199866652, alpha: 1)], gradient: .horizontal)
    }
    
    @objc
    private func addVideoButtonAction() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { [unowned self] _ in
            DispatchQueue.main.async { [unowned self] in
                present(self.imagePickerController, animated: true)
            }
        })
    }
    
}

private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupMainButton()
        setupLabels()
        setupMainImage()
    }
    
    func setupMainButton() {
        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            mainButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func setupLabels() {
        [mainLabel, mainSubLabel].forEach({ view.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainSubLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            mainSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            mainSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    func setupMainImage() {
        mainImageView.frame = view.bounds
        view.insertSubview(mainImageView, at: 0)
    }
}

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let targetVC = ARTVViewController(videoURL: videoURL)
            navigationController?.pushViewController(targetVC, animated: true)
        }
        
        imagePickerController.dismiss(animated: true)
    }
    
}
