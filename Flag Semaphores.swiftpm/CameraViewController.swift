//
//  File.swift
//  
//
//  Created by Amy While on 08/04/2023.
//

import UIKit
import AVFoundation
import Vision

public class CameraViewController: UIViewController {
    
    private let programCoordinator: ProgramCooridinator
    public weak var delegate: CameraViewControllerDelegate?
    
    var windowOrientation: UIInterfaceOrientation {
        view.window?.windowScene?.interfaceOrientation ?? .portrait
    }
    
    let previewView: PreviewView
   
    let mappedUIImageView = ImageContainer(frame: .zero)

    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    let videoOutput = AVCaptureVideoDataOutput()
    let videoDevice: AVCaptureDevice? =  {
        let frontCameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera,
                                                                                         .builtInTrueDepthCamera,
                                                                                         .builtInWideAngleCamera,
                                                                                         .builtInTripleCamera],
                                                                           mediaType: .video, position: .front)
        return frontCameraDiscoverySession.devices.first
    }()
    
    var videoDeviceInput: AVCaptureDeviceInput?
    let captureSession = AVCaptureSession()
    
    let videoQueue = DispatchQueue(label: "video-capture-queue")
    let analysisQueue = DispatchQueue(label: "video-analysis-queue")
    
    var currentRequiredPiece: Characters? {
        didSet {
            guard let currentRequiredPiece else {
                return
            }
            #if DEBUG
            print("Current Required Piece: \(currentRequiredPiece)")
            #endif
            previewView.set(character: currentRequiredPiece)
        }
    }
    let mode: ProgramMode
    
    public init(mode: ProgramMode) {
        self.mode = mode
        previewView = PreviewView(mode: mode)
        programCoordinator = ProgramCooridinator(mode: mode)
        super.init(nibName: nil, bundle: nil)
        programCoordinator.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCameraSession()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                if granted {
                    self?.setupCameraSession()
                } else {
                    self?.error("Permission not granted")
                }
            })
            break
        default:
            self.error("Unknown Camera Error")
            break
        }
        
        stackView.addArrangedSubview(previewView)
        stackView.addArrangedSubview(mappedUIImageView)
    
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func error(_ error: String) {
        let alert = UIAlertController(title: "Error Using Camera", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }
    
    private func setupCameraSession() {
        do {
            guard let videoDevice else {
                self.error("Unable to find available camera.")
                return
            }
            self.videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            self.error(error.localizedDescription)
            return
        }

        self.captureSession.sessionPreset = .high
        self.videoOutput.setSampleBufferDelegate(self, queue: self.videoQueue)
        self.videoOutput.alwaysDiscardsLateVideoFrames = true
        self.captureSession.addInput(self.videoDeviceInput!)
        self.captureSession.addOutput(self.videoOutput)
        self.videoQueue.async {
            self.captureSession.startRunning()
        }
        
        self.programCoordinator.start()
    }
    
    private func bodyPoseHandler(image: CGImage, request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        var image = image
        // Process each observation to find the recognized body pose points.
        observations.forEach {
            if let _image = processObservation($0, image: image) {
                image = _image
            }
        }
        DispatchQueue.main.async {
            let mappedImage = UIImage(cgImage: image)
            let orientedImage = UIImage(cgImage: image, scale: mappedImage.scale, orientation: self.currentImageOrientation())
            self.mappedUIImageView.image = orientedImage
        }
    }
    
    func drawCirclesAndLines(on cgImage: CGImage, points: [CGPoint], scale: CGFloat = 1, radius: CGFloat = 17.5, lineWidth: CGFloat = 8.5, color: UIColor = .red) -> CGImage? {
        guard let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        context.draw(cgImage, in: CGRect(origin: .zero, size: imageSize))

        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)

        for (index, point) in points.enumerated() {
            let circleRect = CGRect(x: point.x * scale - radius, y: point.y * scale - radius, width: radius * 2, height: radius * 2)
            context.fillEllipse(in: circleRect)

            if index > 0 {
                let previousPoint = points[index - 1]
                context.move(to: CGPoint(x: previousPoint.x * scale, y: previousPoint.y * scale))
                context.addLine(to: CGPoint(x: point.x * scale, y: point.y * scale))
                context.strokePath()
            }
        }

        return context.makeImage()
    }
    
    func currentImageOrientation() -> UIImage.Orientation {
        switch windowOrientation {
        case .portrait:
            return .up
        case .portraitUpsideDown:
            return .down
        case .landscapeLeft:
            return .right
        case .landscapeRight:
            return .left
        default:
            return .right
        }
    }
    
    func processObservation(_ observation: VNHumanBodyPoseObservation, image: CGImage) -> CGImage? {
        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.all) else { return nil }
        
        // Draw around the image, marking points of intersest
        // Highlight every point of the body because funny
        var image = image
        let imageSize = CGSize(width: image.width, height: image.height)
        
        let pointNames: [VNHumanBodyPoseObservation.JointName] = [
            .leftWrist,
            .leftElbow,
            .leftShoulder,
            .rightShoulder,
            .rightElbow,
            .rightWrist
        ]
        
        let imagePoints: [CGPoint] = pointNames.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
            
            // Translate the point from normalized-coordinates to image coordinates.
            return VNImagePointForNormalizedPoint(point.location,
                                                  Int(imageSize.width),
                                                  Int(imageSize.height))
        }
        
        if let scannedPoint = ScannedPoint(points: imagePoints) {
            DispatchQueue.main.async { [weak self] in
                self?.programCoordinator.scanned(point: scannedPoint)
            }
        }
        image = drawCirclesAndLines(on: image, points: imagePoints, color: .red)!
        return image
    }
    
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: connection.videoOrientation.cgOrientation, options: [:])
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer)
        let orientedCIImage = ciimage.oriented(connection.videoOrientation.cgOrientation)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(orientedCIImage, from: orientedCIImage.extent)!
        
        analysisQueue.async { [self] in
            do {
                let request = VNDetectHumanBodyPoseRequest { [weak self] request, error -> Void in
                    self?.bodyPoseHandler(image: cgImage, request: request, error: error)
                }
                try imageRequestHandler.perform([request])
            } catch {
                #if DEBUG
                print("Error: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
}

extension CameraViewController: ProgramCoordinatorDelegate {
    
    public func didCompleteMode() {
        self.navigationController?.popViewController(animated: true)
        switch mode {
        case .learn:
            self.delegate?.didComplete(title: "Congratulations!", message: "You successfully practiced each letter in flag semaphores, are you ready for a challenge?")
        case .game:
            if let _highScore = UserDefaults.standard.object(forKey: "HighScore"),
               let highScore = _highScore as? Int {
                if programCoordinator.score > highScore {
                    self.delegate?.didComplete(title: "Well Done!", message: "You beat your high score and got \(programCoordinator.score), can you do even better?")
                } else {
                    self.delegate?.didComplete(title: "Bad Luck", message: "You didn't beat your high score of \(highScore), keep trying. You got \(programCoordinator.score)")
                }
            } else {
                self.delegate?.didComplete(title: "Congratulations!", message: "You got a score of \(programCoordinator.score), think you can beat it?")
            }
            UserDefaults.standard.set(programCoordinator.score, forKey: "HighScore")
        }
    }
    
    public func didCompleteCalibration() {
        previewView.hasCalibrated = true
        previewView.firstLabel.set(text: "Calibration Complete", animate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else {
                return
            }
            self.programCoordinator.start()
        }
    }
    
    public func nextCharacter(character: Characters) {
        self.currentRequiredPiece = character
    }
    
    public func timerUpdate(secondsLeft: Int) {
        previewView.set(time: secondsLeft)
    }
    
}

public protocol CameraViewControllerDelegate: AnyObject {
    
    func didComplete(title: String, message: String) 
        
}
