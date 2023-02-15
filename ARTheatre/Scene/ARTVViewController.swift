import UIKit
import SceneKit
import ARKit

class ARTVViewController: UIViewController, ARSCNViewDelegate {
    
    private lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.delegate = self
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    private var videoURL: URL!
    private var player: AVPlayer!
    
    init(videoURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.videoURL = videoURL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateNavigationPanel()
        setupSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startARTV()
    }
    
    @objc
    private func backButtonAction() {
        sceneView.session.pause()
        player.pause()
        navigationController?.popToRootViewController(animated: true)
    }
    
}

private extension ARTVViewController {
    
    func setupSceneView() {
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func startARTV() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { response in
            switch response {
            case true:
                self.addARTheatre()
            case false:
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                print("Error getting access to camera")
            }
        })
    }
    
    func runScene() {
        let configuration = ARImageTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func addARTheatre() {
        player = AVPlayer(url: videoURL)
        let tvGeo = SCNPlane(width: 1.6, height: 0.9)
        let tvNode = SCNNode(geometry: tvGeo)
        
        tvGeo.firstMaterial?.diffuse.contents = player
        tvGeo.firstMaterial?.isDoubleSided = true
        
        tvNode.position.z = -1.5
        
        sceneView.scene.rootNode.addChildNode(tvNode)
        
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { [unowned self] (notification) in
            player.seek(to: CMTime.zero)
            player.play()
            print("Looping Video")
        }
    }
    
    func configurateNavigationPanel() {
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        let backButton = UIBarButtonItem(image: image,
                                         style: .done,
                                         target: self,
                                         action: #selector(backButtonAction))
        
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
}
