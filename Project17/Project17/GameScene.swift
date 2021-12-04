//
//  GameScene.swift
//  Project17
//
//  Created by Enrique Casas on 12/1/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    var runCount = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
//        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("Timer fired")
            self.runCount += 1
            
            guard let enemy = self.possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            self.addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            if self.runCount == 20 {
                timer.invalidate()
            }
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        gameTimer = Timer.scheduledTimer(timeInterval: 38, target: self, selector: #selector(fireTimerAgain), userInfo: nil, repeats: false)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
//    @objc func createEnemy() {
//        guard let enemy = possibleEnemies.randomElement() else { return }
//
//        let sprite = SKSpriteNode(imageNamed: enemy)
//        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
//        addChild(sprite)
//
//        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
//        sprite.physicsBody?.categoryBitMask = 1
//        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
//        sprite.physicsBody?.angularVelocity = 5
//        sprite.physicsBody?.linearDamping = 0
//        sprite.physicsBody?.angularDamping = 0
//
//    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.position = CGPoint(x: 100, y: 384)
    }
    
    @objc func fireTimer() {
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { timer in
            self.runCount += 1
            
            guard let enemy = self.possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            self.addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            if self.runCount == 40 {
                timer.invalidate()
            }
        }
    }
    
    @objc func fireTimerAgain() {
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
            guard let enemy = self.possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            self.addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
        }
    }
    
}
