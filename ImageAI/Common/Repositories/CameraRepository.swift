//
//  CameraRepository.swift
//  ImageAI
//
//  Created by Martin Lukacs on 08/08/2021.
//

import AVFoundation
import Combine

protocol CameraManager {
    var session: AVCaptureSession { get }
    var videoDataOutput: AVCaptureVideoDataOutput { get }
    var canStartSession: CurrentValueSubject<Bool, Never> { get }

    func checkCameraRights()
}

final class CameraRepository: CameraManager {
    let session = AVCaptureSession()
    var canStartSession: CurrentValueSubject<Bool, Never> = .init(false)
    let videoDataOutput = AVCaptureVideoDataOutput()
    private var bufferSize: CGSize = .zero

    func checkCameraRights() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUpCameraSession()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                if status {
                    self?.setUpCameraSession()
                }
            }
        case .denied:
            // TODO: return errror
            return
        default:
            return
        }
    }
}

extension CameraRepository {
    private func setUpCameraSession() {
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                throw "Could not set Up the device camera"
            }
            let videoInput = try AVCaptureDeviceInput(device: device)

            session.beginConfiguration()

            guard session.canAddInput(videoInput) else {
                print("Could not add video device input to the session")
                session.commitConfiguration()
                return
            }
            session.addInput(videoInput)
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
                // Add a video data output
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
//                videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
//                videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            } else {
                print("Could not add video data output to the session")
                session.commitConfiguration()
                return
            }
            let captureConnection = videoDataOutput.connection(with: .video)
            // Always process the frames
            captureConnection?.isEnabled = true
            do {
                try device.lockForConfiguration()
                let dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
                bufferSize.width = CGFloat(dimensions.width)
                bufferSize.height = CGFloat(dimensions.height)
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
            session.commitConfiguration()
            canStartSession.send(true)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension String: Error {} // Enables you to throw a string

extension String: LocalizedError { // Adds error.localizedDescription to Error instances
    public var errorDescription: String? { self }
}
