import os
import json
import sys
import logging

# Configure logging to suppress stderr output from libraries
logging.getLogger('google_auth_oauthlib').setLevel(logging.ERROR)
logging.getLogger('werkzeug').setLevel(logging.ERROR)

try:
    from google_auth_oauthlib.flow import InstalledAppFlow
except ImportError:
    print("Error: 'google-auth-oauthlib' is required.")
    print("Run: pip install google-auth-oauthlib")
    sys.exit(1)

# Scopes required for Vertex AI
SCOPES = ['https://www.googleapis.com/auth/cloud-platform']
# Standard location for ADC
CREDENTIALS_PATH = os.path.expanduser('~/.config/gcloud/application_default_credentials.json')

def main():
    print("\n\033[1;34mGoogle Cloud Authentication Helper (No gcloud required)\033[0m")
    
    # 1. Client Secret
    client_config = None
    if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
         client_config = sys.argv[1]
    else:
        print("\nTo login, you need an OAuth 2.0 Client ID (Desktop App).")
        print("1. Go to https://console.cloud.google.com/apis/credentials")
        print("2. Create Credentials > OAuth client ID > Application type: Desktop app")
        print("3. Download the JSON file.")
        print("-----------------------------------------------------")
        path = input("Enter path to your client_secret.json: ").strip()
        # Remove quotes if user added them
        path = path.strip("'" ).strip('"')
        
        if os.path.exists(path):
            client_config = path
        else:
            print(f"\033[1;31mError: File not found at {path}\033[0m")
            return

    # 2. Perform Auth
    try:
        print("\n\033[1;33mStarting terminal-based authentication...\033[0m")
        print("(Copy the link below to your browser if it doesn't open automatically)")
        flow = InstalledAppFlow.from_client_secrets_file(client_config, SCOPES)
        # run_console for headless/terminal environments
        creds = flow.run_console()
    except Exception as e:
        print(f"\nError during auth: {e}")
        print("\n\033[1;33mTrying alternative method...\033[0m")
        try:
            # Try with open_browser=False
            flow = InstalledAppFlow.from_client_secrets_file(client_config, SCOPES)
            creds = flow.run_local_server(port=0, open_browser=False)
        except Exception as e2:
            print(f"\nError during auth: {e2}")
            print("\n\033[1;31mAuthentication failed. Please ensure you have internet connection.\033[0m")
            return

    # 3. Save as ADC
    # ADC format for user credentials
    adc_data = {
        "client_id": flow.client_config['client_id'],
        "client_secret": flow.client_config['client_secret'],
        "refresh_token": creds.refresh_token,
        "type": "authorized_user"
    }
    
    os.makedirs(os.path.dirname(CREDENTIALS_PATH), exist_ok=True)
    with open(CREDENTIALS_PATH, 'w') as f:
        json.dump(adc_data, f, indent=2)
        
    print(f"\n\033[1;32mSuccess! Credentials saved to: {CREDENTIALS_PATH}\033[0m")

if __name__ == '__main__':
    main()
