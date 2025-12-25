#!/usr/bin/env python3
"""
AntiGravity Proxy Server
Simple proxy to handle Google internal authentication
"""

import json
import os
import sys
import http.server
import socketserver
import urllib.parse
import urllib.request
from datetime import datetime

class AntiGravityProxyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

        if self.path == '/health':
            response = {"status": "ok", "service": "antigravity-proxy"}
            self.wfile.write(json.dumps(response).encode())
        elif self.path == '/':
            # Simple UI
            html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>AntiGravity Proxy</title>
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; }
                    .container { max-width: 800px; margin: 0 auto; }
                    .auth-section { background: #f5f5f5; padding: 20px; margin: 20px 0; }
                    input { padding: 10px; margin: 5px; }
                    button { padding: 10px 20px; background: #4285f4; color: white; border: none; cursor: pointer; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>AntiGravity Proxy Server</h1>
                    <div class="auth-section">
                        <h2>Google Authentication</h2>
                        <p>This proxy handles authentication for Google Internal AI models.</p>
                        <p>Status: <span id="status">Not authenticated</span></p>
                    </div>
                    <div class="auth-section">
                        <h2>Usage</h2>
                        <p>API Endpoint: <code>http://localhost:8080/v1</code></p>
                        <p>Compatible with OpenAI/Anthropic API format.</p>
                    </div>
                </div>
            </body>
            </html>
            """
            self.wfile.write(html.encode())
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path.startswith('/v1/'):
            self.handle_anthropic_api()
        else:
            self.send_error(404)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

    def handle_anthropic_api(self):
        # Handle Anthropic-compatible API
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)

        try:
            request_data = json.loads(post_data.decode())
            messages = request_data.get('messages', [])
            model = request_data.get('model', 'gemini-2.0-flash')

            # Set CORS headers
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Content-Type', 'application/json')
            self.end_headers()

            # For now, return a mock response
            # In production, this would call the actual AntiGravity API
            response = {
                "id": f"msg_{datetime.now().timestamp()}",
                "type": "message",
                "role": "assistant",
                "content": [
                    {
                        "type": "text",
                        "text": f"[AntiGravity Proxy] Received request for model: {model}\n\nThis is a proxy response. The actual implementation would:\n1. Authenticate with Google internal systems\n2. Route to AntiGravity API\n3. Return the real model response\n\nYour message: {messages[-1]['content'] if messages else 'No message'}"
                    }
                ],
                "model": model,
                "stop_reason": "end_turn",
                "stop_sequence": None,
                "usage": {
                    "input_tokens": 10,
                    "output_tokens": 50
                }
            }

            self.wfile.write(json.dumps(response).encode())

        except Exception as e:
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_response = {
                "error": {
                    "type": "api_error",
                    "message": str(e)
                }
            }
            self.wfile.write(json.dumps(error_response).encode())

    def log_message(self, format, *args):
        # Suppress logs for cleaner output
        pass

def main():
    PORT = 8080

    # Check if auth exists
    auth_dir = os.path.expanduser("~/.config/claude-all/antigravity")
    auth_files = []
    if os.path.exists(auth_dir):
        auth_files = [f for f in os.listdir(auth_dir) if f.endswith('.json')]

    print("=" * 60)
    print("AntiGravity Proxy Server")
    print("=" * 60)
    print(f"Port: {PORT}")
    print(f"Auth files found: {len(auth_files)}")

    if auth_files:
        print("✓ Authentication files available")
        for f in auth_files:
            print(f"  - {f}")
    else:
        print("⚠️  No authentication files found")
        print("  Run: python3 setup_google_internal_auth.py")

    print()
    print("Starting server...")
    print(f"URL: http://localhost:{PORT}")
    print(f"API: http://localhost:{PORT}/v1")
    print()
    print("Press Ctrl+C to stop")
    print("=" * 60)

    with socketserver.TCPServer(("", PORT), AntiGravityProxyHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down...")
            httpd.shutdown()

if __name__ == "__main__":
    main()