#!/usr/bin/env python3
"""
Simple HTTP proxy for AntiGravity API
"""
import http.server
import json
import os
import socketserver
import subprocess
import sys
import urllib.parse
import urllib.request

class ProxyHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)

        # Set CORS headers
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

        if self.path == '/v1/messages':
            # Parse the request
            try:
                request_data = json.loads(post_data.decode())
                messages = request_data.get('messages', [])
                model = request_data.get('model', 'gemini-2.0-flash-exp')

                # Call antigravity helper
                result = subprocess.run([
                    sys.executable,
                    sys.argv[1] if len(sys.argv) > 1 else '/home/.local/bin/antigravity_helper.py',
                    'chat',
                    sys.argv[2] if len(sys.argv) > 2 else os.environ.get('ANTIGRAVITY_AUTH_FILE', ''),
                    model,
                    json.dumps(messages)
                ], capture_output=True, text=True)

                if result.returncode == 0:
                    response = result.stdout
                else:
                    response = json.dumps({
                        'error': {
                            'type': 'api_error',
                            'message': result.stderr or 'Unknown error'
                        }
                    })
            except Exception as e:
                response = json.dumps({
                    'error': {
                        'type': 'api_error',
                        'message': str(e)
                    }
                })

            self.wfile.write(response.encode())

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

    def log_message(self, format, *args):
        # Suppress log messages
        pass

if __name__ == '__main__':
    PORT = 8123
    with socketserver.TCPServer(("", PORT), ProxyHandler) as httpd:
        print(f"Proxy server running on port {PORT}")
        # Serve one request then exit
        httpd.handle_request()
