//
//  GestureHandler.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit

final class GestureHandler: NSObject {
    
    /// Enable or disable pan gesture interactions
    var isInteractionsEnabled = true
    /// Callback on card close
    var onCardClose: (() -> ())?
    /// Card height to be used for pan translation
    var cardHeight: CGFloat = 300
    /// Animation duration
    var animationDuration: TimeInterval = 0.5
    /// Animation damping ratio
    var animationDampingRatio: CGFloat = 0.9
    
    private var animations = [CardAnimation]()
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
    /// Progress of the animation that is registered
    private var lastProgress: CGFloat = 0
    /// Percentage of the card movement to go to next card state
    private let closeProgress: CGFloat = 0.2
    
    
    private var cardVisible = false
    private var cardState: CardState {
        get { return cardVisible ? .opened : .closed }
        set { cardVisible = (newValue == .opened) }
    }
    private var nextCardState: CardState {
        get { return cardVisible ? .closed: .opened }
    }
    
    
    /// Add animation to be executed
    /// - Parameter animation: card animation with open and close
    func addAnimation(_ animation: CardAnimation) {
        animations.append(animation)
    }
    
    
    @objc func handleCardPan(recogniser: UIPanGestureRecognizer) {
        if isInteractionsEnabled == false {
            return
        }
        
        switch recogniser.state {
            case .began:
                startInteractiveTransition(forState: nextCardState, duration: 1)
                
            case .changed:
                let translation = recogniser.translation(in: recogniser.view)
                let progress = translation.y / cardHeight
                lastProgress = progress
                updateInteractiveTransition(with: progress)
                
            case .ended:
                if (lastProgress < closeProgress) {
                    stopAndGoToStartPositionInteractiveTransition()
                } else {
                    continueInteractiveTransition()
                }
    
            default:
                break
        }
    }
    
    
    func animateTransitionIfNeeded (with state: CardState, duration: TimeInterval? = nil, completion: (() -> ())? = nil) {
        let duration = duration ?? animationDuration
        
        animations.forEach { animation in
            let cardAnimations = animation.getAnimation(for: state)
            let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: animationDampingRatio, animations: cardAnimations)
            animator.startAnimation()
            runningAnimations.append(animator)
        }
        
        
        runningAnimations.first?.addCompletion { [weak self] _ in
            guard let self = self else { return }
            self.cardVisible = !self.cardVisible
            self.runningAnimations.removeAll()
            completion?()
            
            if self.cardVisible == false && self.lastProgress >= self.closeProgress {
                self.onCardClose?()
            }
        }
    }
    
    /**
    Starts an interactive Card transition

    - Parameter state: The card state which is either "Expanded" or "Collapsed".
    - Parameter duration: Duration of the animation.
    */
    private func startInteractiveTransition (forState state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(with: state)
        }

        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    /**
    Updates animators' fraction of the animation that is completed

    - Parameter fractionCompleted: fraction of the animation calculated beforehand.
    */
    private func updateInteractiveTransition (with fractionCompleted: CGFloat) {
       for animator in runningAnimations {
           animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
       }
    }
    
    /**
    Continues all remaining animations
    */
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    /**
    Stops animation and goes to start of the animation
    */
    private func stopAndGoToStartPositionInteractiveTransition() {
        for animator in runningAnimations {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .current)
        }
        self.runningAnimations.removeAll()
        animateTransitionIfNeeded(with: nextCardState, duration: 0)

    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension GestureHandler: UIGestureRecognizerDelegate  {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {}
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {}
    
    // Enable multiple gesture recognition
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }
}
