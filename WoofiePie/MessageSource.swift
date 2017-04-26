//
//  MessageSource.swift
//  WoofiePie
//
//  Created by Ravi on 25/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import JSQMessagesViewController


enum SourceType {
    case Incoming , Outgoing
}

class MessageAvatarAndBubbleImageDataSource :  NSObject ,  JSQMessageBubbleImageDataSource , JSQMessageAvatarImageDataSource {
   
    
    
    private var sourceType : SourceType
    init(sourceType : SourceType ){
        self.sourceType = sourceType
    }
    func avatarImage() -> UIImage! {
        return UIImage()
    }
    func avatarHighlightedImage() -> UIImage! {
        return UIImage()
    }
    
    func avatarPlaceholderImage() -> UIImage! {
        return UIImage()
    }
    func messageBubbleImage() -> UIImage! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        
        if self.sourceType == .Incoming{
            return bubbleFactory?.incomingMessagesBubbleImage(with: .red).messageBubbleImage
        }
        else {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .blue).messageBubbleImage
        }
        
        
    }
    func messageBubbleHighlightedImage() -> UIImage! {
        
        if self.sourceType == .Incoming{
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.red).messageBubbleImage
        }
        else {
           return  JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.blue).messageBubbleImage
        }
    }
}
