
import logging

logger = logging.getLogger(__name__)

class EmailService:
    def __init__(self):
        # In a real app, initialize SMTP client or 3rd party email provider here
        pass

    def send_mission_briefing(self, to_email: str, drop_title: str, drop_domain: str, resources: list[str] = None):
        """
        Simulates sending a mission briefing email.
        """
        subject = f"MISSION INTEL: {drop_title} [{drop_domain.upper()}]"
        
        # Professional HTML Template Mock
        body = f"""
        <html>
            <body>
                <h1>MISSION DEPLOYMENT CONFIRMED</h1>
                <p>Agent,</p>
                <p>You have requested the intelligence package for <b>{drop_title}</b>.</p>
                
                <h3>MISSION DIRECTIVES:</h3>
                <ul>
                    <li><b>Domain:</b> {drop_domain}</li>
                    <li><b>Status:</b> READY FOR EXECUTION</li>
                </ul>
                
                <h3>ATTACHED ASSETS:</h3>
                <ul>
                    <li>📄 Briefing Document (PDF)</li>
                    <li>🎨 Design System (Figma)</li>
                    <li>🔗 API Access Keys</li>
                    <li>💻 Starter Repository</li>
                </ul>
                
                <p><i>Ensure secure environment before initializing code execution.</i></p>
                <p>GOOD LUCK.</p>
                
                <hr>
                <small>DEVAPP HQ // SECURE TRANSMISSION</small>
            </body>
        </html>
        """
        
        # Log to console to simulate sending
        logger.info(f"--- [MOCK EMAIL SENT] ---")
        logger.info(f"To: {to_email}")
        logger.info(f"Subject: {subject}")
        logger.info(f"Body: User has received the mission intel.")
        logger.info(f"-------------------------")
        
        return True
