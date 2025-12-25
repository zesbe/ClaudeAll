#!/usr/bin/env python3
import os
import sys
import json
import subprocess
import time
import signal
import shutil
import platform
import glob

# Constants
CONFIG_DIR = os.path.expanduser("~/.config/claude-master")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")
LITELLM_PORT = 8555
LITELLM_HOST = f"http://127.0.0.1:{LITELLM_PORT}"
CLAUDE_SESSIONS_DIR = os.path.expanduser("~/.claude/sessions") # Standard claude-code session path

# Colors
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def ensure_config():
    if not os.path.exists(CONFIG_DIR):
        os.makedirs(CONFIG_DIR)
    if not os.path.exists(CONFIG_FILE):
        default_config = {
            "default_provider": None,
            "api_keys": {},
            "system_prompt": None,
            "last_model": {}
        }
        save_config(default_config)

def load_config():
    ensure_config()
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

def save_config(config):
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)

def check_dependencies():
    """Check and install required dependencies with proper error handling"""
    missing = []
    installation_errors = []

    # Check for npm
    if not shutil.which("npm"):
        missing.append("npm")

    # Check for claude-code CLI
    if not shutil.which("claude"):
        print(f"{Colors.WARNING}claude-code not found. Attempting to install...{Colors.ENDC}")
        try:
            result = subprocess.run(["npm", "install", "-g", "@anthropic-ai/claude-code"],
                                  capture_output=True, text=True, check=True)
            print(f"{Colors.GREEN}✓ claude-code installed successfully{Colors.ENDC}")
        except subprocess.CalledProcessError as e:
            error_msg = f"Failed to install claude-code: {e.stderr}"
            print(f"{Colors.FAIL}{error_msg}{Colors.ENDC}")
            installation_errors.append(error_msg)

    # Check and install Python dependencies
    try:
        import litellm
        print(f"{Colors.GREEN}✓ litellm is available{Colors.ENDC}")
    except ImportError:
        print(f"{Colors.WARNING}litellm not found. Attempting to install...{Colors.ENDC}")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "litellm[proxy]"],
                                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{Colors.GREEN}✓ litellm installed successfully{Colors.ENDC}")
        except subprocess.CalledProcessError as e:
            error_msg = f"Failed to install litellm: {e}"
            print(f"{Colors.FAIL}{error_msg}{Colors.ENDC}")
            installation_errors.append(error_msg)

    # Report critical issues
    if missing:
        print(f"{Colors.FAIL}Critical: Missing system dependencies: {', '.join(missing)}{Colors.ENDC}")
        print("Please install the missing packages and try again.")
        sys.exit(1)

    if installation_errors:
        print(f"{Colors.WARNING}Some installations failed. The program may not work correctly.{Colors.ENDC}")
        for error in installation_errors:
            print(f"  - {error}")

def get_ollama_models():
    """Detect local ollama models"""
    if not shutil.which("ollama"):
        return []
    try:
        result = subprocess.run(["ollama", "list"], capture_output=True, text=True)
        lines = result.stdout.strip().split('\n')[1:] # Skip header
        models = [line.split()[0] for line in lines if line]
        return models
    except:
        return []

def start_litellm(model_name, env_vars={}):
    """Starts LiteLLM proxy in background"""
    print(f"{Colors.BLUE}Starting LiteLLM proxy for {model_name}...{Colors.ENDC}")
    
    # Kill existing
    subprocess.run(f"fuser -k {LITELLM_PORT}/tcp > /dev/null 2>&1", shell=True)
    
    cmd = [sys.executable, "-m", "litellm", "--model", model_name, "--port", str(LITELLM_PORT), "--drop_params"]
    
    # Merge current env with new vars
    current_env = os.environ.copy()
    current_env.update(env_vars)
    
    process = subprocess.Popen(cmd, env=current_env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    # Wait for health check
    print("Waiting for proxy...", end="", flush=True)
    for _ in range(15):
        try:
            subprocess.check_call(["curl", "-s", f"{LITELLM_HOST}/health"], stdout=subprocess.DEVNULL)
            print(f" {Colors.GREEN}Ready!{Colors.ENDC}")
            return process
        except:
            time.sleep(1)
            print(".", end="", flush=True)
    
    print(f"\n{Colors.FAIL}LiteLLM failed to start.{Colors.ENDC}")
    process.kill()
    return None

def run_claude(proxy_pid=None, session_id=None, system_prompt=None):
    """Runs the main claude CLI"""
    env = os.environ.copy()
    env["ANTHROPIC_BASE_URL"] = LITELLM_HOST
    env["ANTHROPIC_API_KEY"] = "sk-litellm-proxy"
    env["ANTHROPIC_MODEL"] = "claude-3-sonnet-20240229" # Dummy
    
    cmd = ["claude"]
    
    if session_id:
        cmd.extend(["--resume", session_id])
    
    if system_prompt:
        cmd.extend(["--system-prompt", system_prompt])
        
    try:
        subprocess.run(cmd, env=env)
    except KeyboardInterrupt:
        pass
    finally:
        if proxy_pid:
            print(f"\n{Colors.BLUE}Stopping proxy...{Colors.ENDC}")
            proxy_pid.kill()

def menu_provider_selection(config):
    providers = [
        "Google Gemini",
        "OpenAI",
        "MiniMax (Direct)",
        "Groq",
        "ZhipuAI (GLM)",
        "Ollama (Local)",
        "Custom"
    ]
    
    print(f"\n{Colors.HEADER}Select Provider:{Colors.ENDC}")
    for i, p in enumerate(providers):
        print(f"{i+1}) {p}")
    
    try:
        choice = int(input("\nChoice: ")) - 1
        if 0 <= choice < len(providers):
            return providers[choice]
    except:
        pass
    return None

def configure_provider(provider, config):
    env_vars = {}
    model_name = ""
    
    if provider == "Google Gemini":
        key = config["api_keys"].get("GEMINI_API_KEY")
        if not key:
            print("Get Key: https://aistudio.google.com/app/apikey")
            key = input("Enter Gemini API Key: ").strip()
            config["api_keys"]["GEMINI_API_KEY"] = key
            save_config(config)
        env_vars["GEMINI_API_KEY"] = key
        model_name = input("Model [default: gemini/gemini-1.5-flash]: ").strip() or "gemini/gemini-1.5-flash"

    elif provider == "OpenAI":
        key = config["api_keys"].get("OPENAI_API_KEY")
        if not key:
            print("Get Key: https://platform.openai.com/api-keys")
            key = input("Enter OpenAI API Key: ").strip()
            config["api_keys"]["OPENAI_API_KEY"] = key
            save_config(config)
        env_vars["OPENAI_API_KEY"] = key
        model_name = input("Model [default: gpt-4o]: ").strip() or "gpt-4o"
        
    elif provider == "Groq":
        key = config["api_keys"].get("GROQ_API_KEY")
        if not key:
            key = input("Enter Groq API Key: ").strip()
            config["api_keys"]["GROQ_API_KEY"] = key
            save_config(config)
        env_vars["GROQ_API_KEY"] = key
        model_name = "groq/llama3-70b-8192"

    elif provider == "Ollama (Local)":
        models = get_ollama_models()
        if models:
            print("\nDetected Ollama Models:")
            for i, m in enumerate(models):
                print(f"{i+1}) {m}")
            idx = int(input("Select model: ")) - 1
            model_name = f"ollama/{models[idx]}"
        else:
            print(f"{Colors.WARNING}No models detected or Ollama not running.{Colors.ENDC}")
            model_name = "ollama/llama3"
            
    elif provider == "Custom":
        model_name = input("Enter LiteLLM model string (e.g. azure/gpt-4): ")
        
    elif provider == "MiniMax (Direct)":
        # MiniMax uses direct endpoint for better performance and reliability
        key = config["api_keys"].get("MINIMAX_API_KEY")
        if not key:
            print(f"{Colors.BLUE}Enter MiniMax API Key:{Colors.ENDC}")
            print("Get it from: https://platform.minimax.io/")
            key = input("API Key: ").strip()
            if not key:
                print(f"{Colors.FAIL}Error: API key is required{Colors.ENDC}")
                return None, None
            config["api_keys"]["MINIMAX_API_KEY"] = key
            save_config(config)

        # Set up environment for direct execution
        os.environ["ANTHROPIC_BASE_URL"] = "https://api.minimax.io/anthropic"
        os.environ["ANTHROPIC_API_KEY"] = key

        try:
            print(f"{Colors.GREEN}Connecting to MiniMax directly...{Colors.ENDC}")
            result = subprocess.run(["claude"], check=True)
            return None, None  # Signal successful direct execution
        except subprocess.CalledProcessError as e:
            print(f"{Colors.FAIL}Error running claude: {e}{Colors.ENDC}")
            return None, None
        except FileNotFoundError:
            print(f"{Colors.FAIL}Error: 'claude' command not found. Please install Claude Code CLI.{Colors.ENDC}")
            return None, None

    return model_name, env_vars

def doctor():
    print(f"\n{Colors.HEADER}Running Diagnostics...{Colors.ENDC}")
    print("1. Checking System...")
    print(f"   OS: {platform.system()} {platform.release()}")
    print(f"   Python: {sys.version.split()[0]}")
    
    print("\n2. Checking Dependencies...")
    for cmd in ["npm", "claude", "python3", "pip", "git", "ollama", "gcloud"]:
        found = shutil.which(cmd)
        status = f"{Colors.GREEN}OK{Colors.ENDC}" if found else f"{Colors.FAIL}Missing{Colors.ENDC}"
        print(f"   {cmd}: {status}")
        
    print("\n3. Checking Termux Specifics...")
    if "ANDROID_ROOT" in os.environ:
        print("   Running in Termux environment.")
        try:
            import cryptography
            print(f"   Cryptography Lib: {Colors.GREEN}OK{Colors.ENDC}")
        except ImportError:
            print(f"   Cryptography Lib: {Colors.FAIL}Missing/Broken{Colors.ENDC}")
            print(f"   {Colors.YELLOW}Tip: Run 'pkg install rust binutils libffi openssl build-essential'{Colors.ENDC}")

def list_sessions():
    if not os.path.exists(CLAUDE_SESSIONS_DIR):
        print("No sessions found.")
        return None
    
    # Simple logic: list folders in session dir
    sessions = sorted(glob.glob(os.path.join(CLAUDE_SESSIONS_DIR, "*")), key=os.path.getmtime, reverse=True)
    if not sessions:
        print("No sessions found.")
        return None

    print(f"\n{Colors.HEADER}Recent Sessions:{Colors.ENDC}")
    display_sessions = []
    for s in sessions[:5]: # Last 5
        sid = os.path.basename(s)
        display_sessions.append(sid)
        print(f"{len(display_sessions)}) {sid}")
    
    try:
        choice = int(input("Select session to resume (0 to cancel): "))
        if choice > 0 and choice <= len(display_sessions):
            return display_sessions[choice-1]
    except:
        pass
    return None

def main():
    check_dependencies()
    config = load_config()
    
    while True:
        clear_screen()
        print(f"{Colors.HEADER}╔════════════════════════════════════════╗{Colors.ENDC}")
        print(f"{Colors.HEADER}║           CLAUDE MASTER CLI            ║{Colors.ENDC}")
        print(f"{Colors.HEADER}╚════════════════════════════════════════╝{Colors.ENDC}")
        print("1. New Chat (Select Provider)")
        print("2. Resume Last Session")
        print("3. List Past Sessions")
        print("4. Settings (Keys & Prompts)")
        print("5. Doctor (Fix Issues)")
        print("6. Exit")
        
        choice = input(f"\n{Colors.BOLD}Select Option: {Colors.ENDC}")
        
        if choice == "1":
            provider = menu_provider_selection(config)
            if provider:
                model, env = configure_provider(provider, config)
                if model: # If None, it means it was handled internally (MiniMax)
                    proc = start_litellm(model, env)
                    if proc:
                        run_claude(proc, system_prompt=config.get("system_prompt"))
                input("\nPress Enter to return to menu...")
                
        elif choice == "2":
            # Resume functionality needs session ID logic from claude-code
            # Since we can't easily get 'last' without parsing, we'll try running claude --resume
            # which usually prompts interactively.
            # But we need the proxy running FIRST.
            # We need to know WHICH provider was used last.
            print(f"{Colors.YELLOW}Resuming requires starting the AI Provider first.{Colors.ENDC}")
            provider = menu_provider_selection(config)
            if provider:
                model, env = configure_provider(provider, config)
                if model:
                    proc = start_litellm(model, env)
                    if proc:
                        # Pass --resume flag only
                        env = os.environ.copy()
                        env["ANTHROPIC_BASE_URL"] = LITELLM_HOST
                        env["ANTHROPIC_API_KEY"] = "sk-litellm-proxy"
                        env["ANTHROPIC_MODEL"] = "claude-3-sonnet-20240229"
                        try:
                            print("Launching Claude in Resume mode...")
                            # claude --resume interactive picker
                            subprocess.run(["claude", "--resume"], env=env) 
                        finally:
                            proc.kill()
                            
        elif choice == "3":
            sid = list_sessions()
            if sid:
                print(f"Resuming {sid}...")
                # Same logic: need provider first
                provider = menu_provider_selection(config)
                if provider:
                    model, env = configure_provider(provider, config)
                    if model:
                        proc = start_litellm(model, env)
                        if proc:
                            run_claude(proc, session_id=sid)
        
        elif choice == "4":
            print(f"\n{Colors.HEADER}Settings{Colors.ENDC}")
            print("1. Set System Prompt (Persona)")
            print("2. Clear API Keys")
            sc = input("Choice: ")
            if sc == "1":
                p = input("Enter new System Prompt (Enter to clear): ")
                config["system_prompt"] = p if p.strip() else None
                save_config(config)
            elif sc == "2":
                config["api_keys"] = {}
                save_config(config)
                print("Keys cleared.")
                time.sleep(1)
                
        elif choice == "5":
            doctor()
            input("\nPress Enter to continue...")
            
        elif choice == "6":
            sys.exit(0)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nGoodbye!")
