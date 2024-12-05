//
//  VideoView.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import UIKit
import WebKit


protocol VideoViewDelegate: AnyObject {
    func videoViewDelegateDidTapSound(_ videoView: VideoView)
    func videoViewDelegateVideoLoadDidFinish(_ videoView: VideoView)
}

class VideoView: UIView, WKNavigationDelegate {
    
    private let movieImageView : UIImageView = {
        let image : UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    public let soundImageView : UIImageView = {
        let image : UIImageView = UIImageView()
        image.layer.borderWidth = 1
        image.image = UIImage(systemName: "speaker.slash")
        image.layer.masksToBounds = false
        image.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.tintColor = .white
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    public let videoView : WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let webConfiguration = WKWebViewConfiguration()
                // Add message handler to listen for JavaScript messages
        webConfiguration.defaultWebpagePreferences = preferences
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        let wb = WKWebView(frame: .zero, configuration: webConfiguration)
        wb.allowsLinkPreview = true
        wb.isUserInteractionEnabled = false
        wb.translatesAutoresizingMaskIntoConstraints = false
        return wb
    }()
    
    
    var delegate: VideoViewDelegate?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(videoView)
        addSubview(movieImageView)
        addSubview(soundImageView)
        
        
        soundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSoundView)))
        videoView.navigationDelegate = self
        applyConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.videoViewDelegateVideoLoadDidFinish(self)
    }
    
    
    @objc private func didTapSoundView(){
        delegate?.videoViewDelegateDidTapSound(self)
    }
    
    
    
    func playTralier(){
        videoView.evaluateJavaScript("playVideo();") { (result, error) in
            if let error = error {
                print("Error starting video: \(error.localizedDescription)")
                self.movieImageView.isHidden = false
            }
        }
        
        movieImageView.isHidden = true
    }
    
    func pauseTralier(){
        videoView.evaluateJavaScript("pauseVideo();") { (result, error) in
            if let error = error {
                print("Error starting video: \(error.localizedDescription)")
            }
        }
        
        movieImageView.isHidden = false
    }
    
    
    
    func muteVideo() {
        
        soundImageView.image = UIImage(systemName: "speaker.slash")
        let jsCode = "document.querySelector('iframe').contentWindow.postMessage('{\"event\":\"command\",\"func\":\"mute\",\"args\":[]}', '*');"
        videoView.evaluateJavaScript(jsCode) { (result, error) in
            if let error = error {
                print("Error muting video: \(error.localizedDescription)")
            }
        }
    }

    // Unmute the video using JavaScript
    func unmuteVideo() {
        
        soundImageView.image = UIImage(systemName: "speaker")
        
        let jsCode = "document.querySelector('iframe').contentWindow.postMessage('{\"event\":\"command\",\"func\":\"unMute\",\"args\":[]}', '*');"
        videoView.evaluateJavaScript(jsCode) { (result, error) in
            if let error = error {
                print("Error unmuting video: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func configure(with posterUrl : URL, videoID: String){
        
        movieImageView.downloaded(from: posterUrl, contentMode: .scaleToFill)
        
        
        let htmlString = """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Full-Width Full-Height YouTube Video</title>
                    <style>
                        html, body {
                            margin: 0;
                            padding: 0;
                            height: 100%;
                        }
                        #player {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                        }
                        iframe {
                            width: 100%;
                            height: 100%;
                            border: none;
                        }
                    </style>
                </head>
                <body>
                    <div id="player"></div>
                    <script>
                        var tag = document.createElement('script');
                        tag.src = "https://www.youtube.com/iframe_api";
                        var firstScriptTag = document.getElementsByTagName('script')[0];
                        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

                        var player;

                        function onYouTubeIframeAPIReady() {
                            player = new YT.Player('player', {
                                height: '100%',
                                width: '100%',
                                videoId: '\(videoID)',
                                playerVars: {
                                    'controls': 0,
                                    'playsinline': 1,
                                    'modestbranding': 1,
                                    'rel': 0,
                                    'mute': 1,
                                },
                                events: {
                                    'onReady': onPlayerReady,
                                    'onStateChange': onPlayerStateChange
                                }
                            });
                        }

                        function onPlayerReady(event) {
                            console.log('Player is ready');
                        }

                        function onPlayerStateChange(event) {
                            if (event.data == YT.PlayerState.PLAYING) {
                                window.webkit.messageHandlers.videoEnded.postMessage("Video his plaiyng");
                            }
                            if (event.data == YT.PlayerState.ENDED) {
                                window.webkit.messageHandlers.videoEnded.postMessage("Video has ended");
                            }
                        }
                
                         function playVideo() {
                            player.playVideo();
                        }

                         function pauseVideo() {
                            player.pauseVideo();
                         }
                
                
                        function onPlayerStateChange(event) {
                                
                         }
                    </script>
                </body>
                </html>
                """
                
                // Load the HTML string into the WKWebView
        videoView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
    private func  applyConstraints(){
        
        let videoViewConstraints = [
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        
        
        let movieImageViewConstraints = [
            movieImageView.topAnchor.constraint(equalTo: self.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        

        
        let soundImageViewConstraints = [
            soundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            soundImageView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -10),
            soundImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
            soundImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
        ]
        
        NSLayoutConstraint.activate(videoViewConstraints)
        NSLayoutConstraint.activate(movieImageViewConstraints)
        NSLayoutConstraint.activate(soundImageViewConstraints)
    }
}
