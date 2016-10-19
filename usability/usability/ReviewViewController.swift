//
//  ReviewViewController.swift
//  usability
//
//  Created by Aman Gahlot on 9/28/16.
//  Copyright © 2016 goibibo. All rights reserved.


import UIKit
import UXCam
import Speech

class ReviewViewController: UIViewController, SFSpeechRecognizerDelegate, UITextViewDelegate {

    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingIconImageView: UIImageView!
    @IBOutlet weak var textFieldPlaceHolderLabel: UILabel!
    
    
//    var enableMic: Bool?
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "en-IN"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
    }

    //MARK:- Private Methods
    
    func doInitialConfigurations() {
        
        initializeSpeechRecognizer()
        
        reviewTextField.delegate = self
//        startRecording()
//        addSwipeGestureRecogniser()
    }
    
  
    
    //MARK:- Speech Recognition Methods
    
    func initializeSpeechRecognizer() {
        
        speechRecognizer?.delegate = self
        micButton.isEnabled = false
        //        enableMic = false
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
                
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation {
                self.micButton.isEnabled = isButtonEnabled
                //                self.enableMic = isButtonEnabled
            }
        }

    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
                print("AudioSession Properties weren't set becuase of an Error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create an SFSpeechAudioBufferRecognitionrequest object")
//        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1023, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        }
        catch {
            print("audioEngine couldn't start because of an error")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.reviewTextField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionTask = nil
                self.micButton.isEnabled = true
//                self.enableMic = true
                
            }
        })
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        if available {
            micButton.isEnabled = true
//            enableMic = true
        } else {
            micButton.isEnabled = false
//            enableMic = false
        }
    }
    
    
    //MARK:- TextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.textFieldPlaceHolderLabel.isHidden = true
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reviewTextField.resignFirstResponder()
    }
    
    
    //MARK:- IBAction Methods

    
    @IBAction func actionMicTapped(_ sender: AnyObject) {
     
        NSLog("mic button tapped", sender.title)
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest.endAudio()
            micButton.isEnabled = false
            recordingLabel.text = "Enable Dictation"
        }
        else {
            startRecording()
            recordingLabel.text = "Recording..."
            if self.textFieldPlaceHolderLabel.isHidden == false {
                self.textFieldPlaceHolderLabel.isHidden = true
            }
        }
    }

    
    @IBAction func actionDoneButtonTapped(_ sender: AnyObject) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest.endAudio()
            //            enableMic = false
            micButton.isEnabled = false
        }
        
        let alertController  = UIAlertController(title: "", message: "Thank you for testing the app. Your feedback has been submitted", preferredStyle: .alert)
        let alertAction  = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true) {
        }
        
        UXCam.stopApplicationAndUploadData()
    }
    
    
}
