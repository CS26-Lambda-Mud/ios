import SpriteKit

extension SKSpriteNode {
    static let textureKey = "Texture Key"
    static var textures: [SKTexture] = []
    
    // Load textures for a sprite node and run that sequence forever
    func loadTextures(named name: String, forKey key: String) {
        // Load atlas
        let atlas = SKTextureAtlas(named: name)
        
        // Collect and sort textures
        SKSpriteNode.textures = atlas.textureNames
            .sorted(by: <)
            .map({ atlas.textureNamed($0) })
        
        // Need at least one texture to continue
        guard !SKSpriteNode.textures.isEmpty else { return }
        
        // Assign size
        self.size = SKSpriteNode.textures[0].size()
        
        // Remove any prevous texture sequence
        self.removeAction(forKey: key)

        // Run texture sequence forever
        let action = SKAction.animate(with: SKSpriteNode.textures, timePerFrame: 0.2)
        let foreverAction = SKAction.repeatForever(action)
        self.run(foreverAction, withKey: key)
        
    }
}
