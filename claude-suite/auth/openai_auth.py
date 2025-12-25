import sys
import os
import json
import webbrowser
import requests
import hashlib
import base64
import secrets
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
import threading

# Configuration
# This Client ID is widely used/found in OpenAI's public SDKs or assumed for CLI apps.
# If this fails, it means OpenAI has restricted it or rotated it.
CLIENT_ID = "pdlLIX2Y72MIl2rhLhTE9VV9bN905kBh" # Common Auth0 Client ID for OpenAI
AUTH_DOMAIN = "auth0.openai.com"
REDIRECT_URI = "http://localhost:3000/callback"
SCOPE = "openid profile email offline_access"
AUDIENCE = "https://api.openai.com/v1"

CREDENTIALS_PATH = os.path.expanduser('~/.config/openai/credentials.json')

class OAuthCallbackHandler(BaseHTTPRequestHandler):
    code = None
    
    def do_GET(self):
        query = urlparse(self.path).query
        params = parse_qs(query)
        
        if 'code' in params:
            OAuthCallbackHandler.code = params['code'][0]
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"<html><body><h1>Login Successful!</h1><p>You can close this tab and return to the terminal.</p></body></html>")
        else:
            self.send_response(400)
            self.wfile.write(b"Missing code parameter.")
            
    def log_message(self, format, *args):
        return # Suppress logging

def generate_pkce_pair():
    verifier = secrets.token_urlsafe(32)
    digest = hashlib.sha256(verifier.encode()).digest()
    challenge = base64.urlsafe_b64encode(digest).decode().rstrip('=')
    return verifier, challenge

def main():
    print("\n\033[1;35mOpenAI OAuth Helper (Experimental)\033[0m")

    try:
        # PKCE
        code_verifier, code_challenge = generate_pkce_pair()

        # Start Listener with error handling
        try:
            server = HTTPServer(('localhost', 3000), OAuthCallbackHandler)
            server_thread = threading.Thread(target=server.handle_request)
            server_thread.start()
        except OSError as e:
            print(f"\n\033[1;31mError: Failed to start callback server: {e}\033[0m")
            print("Please make sure port 3000 is available.")
            return

        # Construct Auth URL
        auth_url = (
            f"https://{AUTH_DOMAIN}/authorize?"
            f"response_type=code&"
            f"client_id={CLIENT_ID}&"
            f"redirect_uri={REDIRECT_URI}&"
            f"scope={SCOPE}&"
            f"audience={AUDIENCE}&"
            f"code_challenge={code_challenge}&"
            f"code_challenge_method=S256"
        )

        print("\n1. Opening browser for login...")
        print(f"URL: {auth_url}")

        try:
            webbrowser.open(auth_url)
        except Exception as e:
            print(f"\n\033[1;33mWarning: Could not open browser automatically: {e}\033[0m")
            print("Please manually open the URL above in your browser.")

        print("\n2. Waiting for callback...")
        server_thread.join(timeout=120)  # 2 minute timeout

        if not OAuthCallbackHandler.code:
            print("\n\033[1;31mError: Failed to capture authorization code or timeout expired.\033[0m")
            print("Please try again and make sure to complete the authentication within 2 minutes.")
            return

        print("\n3. Exchanging code for tokens...")

        token_url = f"https://{AUTH_DOMAIN}/oauth/token"
        payload = {
            "grant_type": "authorization_code",
            "client_id": CLIENT_ID,
            "code_verifier": code_verifier,
            "code": OAuthCallbackHandler.code,
            "redirect_uri": REDIRECT_URI,
        }

        try:
            response = requests.post(token_url, json=payload, timeout=30)
            response.raise_for_status()  # Raise exception for HTTP errors
        except requests.exceptions.RequestException as e:
            print(f"\n\033[1;31mError: Failed to exchange code for tokens: {e}\033[0m")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Response: {e.response.text}")
            return

        tokens = response.json()

        # Save credentials with error handling
        try:
            os.makedirs(os.path.dirname(CREDENTIALS_PATH), exist_ok=True)
            with open(CREDENTIALS_PATH, 'w') as f:
                json.dump(tokens, f, indent=2)

            print(f"\n\033[1;32mSuccess! Access Token acquired.\033[0m")
            print(f"Saved to: {CREDENTIALS_PATH}")
            print("Note: This token is a standard JWT access token, not a 'sk-' API key.")
            print("Use it as a Bearer token in headers.")
        except IOError as e:
            print(f"\n\033[1;33mWarning: Could not save credentials to file: {e}\033[0m")
            print("However, the token was successfully acquired.")
            print("Access Token:", tokens.get('access_token', 'Not available'))

    except Exception as e:
        print(f"\n\033[1;31mUnexpected error during authentication: {e}\033[0m")
        return

if __name__ == "__main__":
    main()
