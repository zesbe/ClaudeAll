#!/usr/bin/env python3
"""
Setup Google Internal AntiGravity Authentication
REPLACE YOUR_CLIENT_ID and YOUR_CLIENT_SECRET below before use!
"""

import os
import json
import webbrowser
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading
import time
import urllib.parse
import urllib.request

class AuthHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if '/callback' in self.path:
            query = urllib.parse.urlparse(self.path).query
            params = urllib.parse.parse_qs(query)

            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            if 'code' in params:
                with open('/tmp/antigravity_auth_code.txt', 'w') as f:
                    f.write(params['code'][0])

                response = """
                <html>
                <body style='font-family: Arial; padding: 40px; text-align: center;'>
                    <h1 style='color: #4285f4;'>✅ Authentication Successful!</h1>
                    <p>You can close this window.</p>
                    <p>AntiGravity is now configured.</p>
                </body>
                </html>
                """
            else:
                response = """
                <html>
                <body style='font-family: Arial; padding: 40px; text-align: center;'>
                    <h1 style='color: red;'>❌ Authentication Failed</h1>
                    <p>Please try again.</p>
                </body>
                </html>
                """

            self.wfile.write(response.encode())

def main():
    print("=" * 70)
    print("GOOGLE INTERNAL - ANTIGRAVITY SETUP")
    print("=" * 70)
    print()

    print("📍 CONFIGURATION REQUIRED:")
    print("1. Open this script and replace YOUR_CLIENT_ID")
    print("2. Replace YOUR_CLIENT_SECRET")
    print("3. You must be a Google employee")
    print("4. Connected to Google VPN/Network")
    print()

    # Configuration - REPLACE THESE!
    client_id = "YOUR_CLIENT_ID"  # REPLACE THIS!
    client_secret = "YOUR_CLIENT_SECRET"  # REPLACE THIS!

    if "YOUR_" in client_id or "YOUR_" in client_secret:
        print("❌ Please configure client_id and client_secret in this script!")
        print("   Edit this file and replace the placeholder values")
        return

    print("🔗 STEP 1 - Opening Google Internal OAuth:")

    auth_url = (
        "https://accounts.google.com/o/oauth2/v2/auth?"
        f"client_id={client_id}&"
        "redirect_uri=http://localhost:8080/callback&"
        "scope=https://www.googleapis.com/auth/cloud-platform+https://www.googleapis.com/auth/generative-language&"
        "response_type=code&"
        "access_type=offline"
    )

    print(f"👉 {auth_url}")
    print()

    try:
        webbrowser.open(auth_url)
        print("✅ Browser opened automatically")
    except:
        print("❌ Could not open browser automatically")

    print()
    print("🔄 STEP 2 - Starting local callback server...")

    server = HTTPServer(('localhost', 8080), AuthHandler)
    server_thread = threading.Thread(target=server.serve_forever)
    server_thread.daemon = True
    server_thread.start()

    print("⏳ Waiting for authentication...")

    for i in range(60):
        if os.path.exists('/tmp/antigravity_auth_code.txt'):
            break
        time.sleep(1)
        if i % 5 == 0:
            print(f"   Waiting... ({i}s)")

    server.shutdown()

    if os.path.exists('/tmp/antigravity_auth_code.txt'):
        with open('/tmp/antigravity_auth_code.txt', 'r') as f:
            auth_code = f.read()

        os.remove('/tmp/antigravity_auth_code.txt')

        print()
        print("🔄 STEP 3 - Exchanging for access token...")

        token_data = {
            'client_id': client_id,
            'client_secret': client_secret,
            'code': auth_code,
            'grant_type': 'authorization_code',
            'redirect_uri': 'http://localhost:8080/callback'
        }

        try:
            req = urllib.request.Request(
                'https://oauth2.googleapis.com/token',
                data=urllib.parse.urlencode(token_data).encode(),
                headers={'Content-Type': 'application/x-www-form-urlencoded'}
            )

            with urllib.request.urlopen(req) as response:
                token_info = json.loads(response.read().decode())

                auth_dir = os.path.expanduser("~/.config/claude-all/antigravity")
                os.makedirs(auth_dir, exist_ok=True)

                auth_file = os.path.join(auth_dir, "google_internal_auth.json")

                credentials = {
                    "type": "authorized_user",
                    "client_id": client_id,
                    "client_secret": client_secret,
                    "access_token": token_info.get('access_token'),
                    "refresh_token": token_info.get('refresh_token', ''),
                    "expiry_date": token_info.get('expires_in', 3600),
                    "label": "Google Internal AntiGravity",
                    "token_uri": "https://oauth2.googleapis.com/token"
                }

                with open(auth_file, 'w') as f:
                    json.dump(credentials, f, indent=2)

                print()
                print("✅ SUCCESS! AntiGravity configured!")
                print("=" * 70)

        except Exception as e:
            print(f"❌ Error getting token: {e}")

if __name__ == "__main__":
    print("Note: This script only works for Google employees")
    print("      connected to Google internal network.")
    print("      You MUST configure client_id and client_secret first!")
    print()
    input("Press Enter to continue...")
    main()