"""
Seed script to create sample conversations for testing the inbox feature.
Run this from the backend directory: python -m app.seed_inbox
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import SessionLocal
from app import models

def seed_conversations():
    db = SessionLocal()
    
    try:
        # Get first user
        user = db.query(models.User).first()
        if not user:
            print("No users found. Please create a user first.")
            return
        
        print(f"Creating sample conversations for user: {user.email}")
        
        # Create sample conversations
        conversations_data = [
            {
                "sender_name": "Sarah Chen",
                "sender_role": "Founder @ NexusAI",
                "sender_email": "sarah@nexusai.com",
                "sender_avatar_color": "#9F7AEA",
                "message_type": models.MessageType.OFFER,
                "subject": "Lead Engineer Position",
                "initial_message": "Hi! I saw your submission for the 'Vector Database' task. The optimization logic was brilliant. Would you be open to a quick chat about a Lead role at NexusAI? We're building something exciting in the AI infrastructure space.",
            },
            {
                "sender_name": "Michael Ross",
                "sender_role": "Talent Acquisition @ Stripe",
                "sender_email": "michael@stripe.com",
                "sender_avatar_color": "#4299E1",
                "message_type": models.MessageType.GIG,
                "subject": "Backend Engineering Opportunity",
                "initial_message": "Hey! We are looking for backend engineers with your skill set. Your recent activity caught our eye, especially the API optimization work. Would you be interested in a short-term project?",
            },
            {
                "sender_name": "David Kim",
                "sender_role": "CTO @ Flux",
                "sender_email": "david@flux.io",
                "sender_avatar_color": "#38B2AC",
                "message_type": models.MessageType.GIG,
                "subject": "Python Optimization Contract",
                "initial_message": "I have a short-term contract available strictly for Python optimization. The project involves improving the performance of our data pipeline. Let me know if you're interested!",
            },
            {
                "sender_name": "Airbnb Careers",
                "sender_role": "Recruiting Team",
                "sender_email": "careers@airbnb.com",
                "sender_avatar_color": "#FC8181",
                "message_type": models.MessageType.OFFER,
                "subject": "Full-Time Job Offer",
                "initial_message": "We have reviewed your profile and would like to extend a Job Offer for the Senior Software Engineer position. Your portfolio shows exactly the kind of expertise we're looking for. Please let us know when you'd be available for a call.",
            },
        ]
        
        for conv_data in conversations_data:
            # Check if conversation already exists
            existing = db.query(models.Conversation).filter(
                models.Conversation.user_id == user.id,
                models.Conversation.sender_email == conv_data["sender_email"]
            ).first()
            
            if existing:
                print(f"  Skipping {conv_data['sender_name']} - already exists")
                continue
            
            # Create conversation
            conv = models.Conversation(
                user_id=user.id,
                sender_name=conv_data["sender_name"],
                sender_role=conv_data["sender_role"],
                sender_email=conv_data["sender_email"],
                sender_avatar_color=conv_data["sender_avatar_color"],
                message_type=conv_data["message_type"],
                subject=conv_data["subject"],
            )
            db.add(conv)
            db.flush()
            
            # Create initial message
            msg = models.Message(
                conversation_id=conv.id,
                is_from_user=False,
                content=conv_data["initial_message"],
            )
            db.add(msg)
            
            print(f"  Created conversation from {conv_data['sender_name']}")
        
        db.commit()
        print("\nSeed completed successfully!")
        
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_conversations()
