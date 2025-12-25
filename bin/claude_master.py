#!/usr/bin/env python3
"""
Claude Master Tool - Advanced UI for Claude Code CLI
Provides enhanced interface with provider switching, history, and more features
"""

import os
import sys
import json
import subprocess
import datetime
from pathlib import Path

class ClaudeMaster:
    def __init__(self):
        self.history_file = Path.home() / '.claude_chat_history.json'
        self.config_file = Path.home() / '.claude_master_config.json'
        self.load_config()

    def load_config(self):
        """Load configuration from file"""
        try:
            with open(self.config_file, 'r') as f:
                self.config = json.load(f)
        except:
            self.config = {
                'default_provider': 1,
                'auto_save_context': True,
                'show_provider_info': True,
                'theme': 'default'
            }

    def save_config(self):
        """Save configuration to file"""
        with open(self.config_file, 'w') as f:
            json.dump(self.config, f, indent=2)

    def clear_screen(self):
        """Clear terminal screen"""
        os.system('clear' if os.name == 'posix' else 'cls')

    def show_banner(self):
        """Show application banner"""
        print(f"""
{'='*60}
    🤖 Claude Master Tool - Advanced Interface
{'='*60}
    📝 Chat History    🔧 Provider Manager    ⚙️  Settings
    🔄 Quick Switch    📊 Usage Stats       💾 Save/Load
{'='*60}
        """)

    def show_providers(self):
        """Display available providers with current selection"""
        providers = [
            ("1", "MiniMax", "🚀 Fast & Reliable", True),
            ("2", "Google Gemini (API)", "🧠 Google AI", True),
            ("3", "Google AntiGravity", "⚡ Internal Google", False),
            ("4", "OpenAI", "🤖 GPT Models", True),
            ("5", "OpenAI (OAuth)", "🔄 Auto-auth", False),
            ("6", "xAI / Grok", "🚀 Real-time", True),
            ("7", "ZhipuAI / GLM", "🇨🇳 Chinese AI", True),
            ("8", "Groq", "⚡ Ultra-fast", True),
            ("9", "Perplexity", "🔍 Live Data", True),
            ("10", "Cohere", "📝 Business AI", True),
            ("11", "DeepSeek", "🧠 Reasoning", True),
            ("12", "Ollama", "💻 Self-hosted", True),
            ("13", "Mistral", "🇫🇷 European AI", True),
            ("14", "Moonshot", "🌙 Kawaii AI", True),
            ("15", "Qwen", "🇨🇳 Alibaba", True),
            ("16", "OpenRouter", "🔀 All-in-one", True),
        ]

        print("\n🤖 Available Providers:")
        print("-" * 60)

        for num, name, desc, has_key in providers:
            key_status = "✅" if has_key else "❌"
            current = "← CURRENT" if int(num) == self.config['default_provider'] else ""
            print(f"  {num}) {name:<20} {desc:<15} {key_status} {current}")

        print()

    def show_chat_history(self):
        """Display chat history"""
        if not self.history_file.exists():
            print("\n📝 No chat history found")
            return

        try:
            with open(self.history_file, 'r') as f:
                history = json.load(f)

            print("\n📝 Recent Chat History:")
            print("-" * 60)

            for i, chat in enumerate(history[-5:], 1):
                date = chat.get('date', 'Unknown')
                provider = chat.get('provider', 'Unknown')
                topic = chat.get('topic', 'No topic')
                print(f"  {i}) {date} - {provider} - {topic}")

        except Exception as e:
            print(f"\n❌ Error loading history: {e}")

    def quick_chat(self):
        """Quick chat with default provider"""
        provider = self.config['default_provider']
        print(f"\n🚀 Starting quick chat with provider {provider}...")

        # Save to history
        self.add_to_history(provider, "Quick Chat")

        # Launch claude-all
        subprocess.run(['claude-all', str(provider)])

    def add_to_history(self, provider, topic):
        """Add chat to history"""
        history = []

        if self.history_file.exists():
            try:
                with open(self.history_file, 'r') as f:
                    history = json.load(f)
            except:
                pass

        history.append({
            'date': datetime.datetime.now().strftime('%Y-%m-%d %H:%M'),
            'provider': f"Provider {provider}",
            'topic': topic
        })

        # Keep only last 50 entries
        history = history[-50:]

        with open(self.history_file, 'w') as f:
            json.dump(history, f, indent=2)

    def switch_provider(self):
        """Switch default provider"""
        self.show_providers()

        try:
            choice = input("\n🔄 Select new provider [1-16]: ").strip()
            if choice.isdigit() and 1 <= int(choice) <= 16:
                self.config['default_provider'] = int(choice)
                self.save_config()
                print(f"✅ Default provider set to {choice}")
            else:
                print("❌ Invalid choice")
        except KeyboardInterrupt:
            print("\n✋ Cancelled")

    def show_settings(self):
        """Display settings menu"""
        print(f"""
⚙️  Settings:
────────────────────────────────────
1) Default Provider: {self.config['default_provider']}
2) Auto-save Context: {'✅' if self.config['auto_save_context'] else '❌'}
3) Show Provider Info: {'✅' if self.config['show_provider_info'] else '❌'}
4) Theme: {self.config['theme']}
5) Reset to Defaults
6) Back to Main Menu
        """)

        try:
            choice = input("\nSelect setting [1-6]: ").strip()

            if choice == '1':
                self.switch_provider()
            elif choice == '2':
                self.config['auto_save_context'] = not self.config['auto_save_context']
                self.save_config()
                print("✅ Auto-save context toggled")
            elif choice == '3':
                self.config['show_provider_info'] = not self.config['show_provider_info']
                self.save_config()
                print("✅ Provider info toggled")
            elif choice == '4':
                themes = ['default', 'dark', 'light']
                print(f"Available themes: {', '.join(themes)}")
                theme = input("Enter theme name: ").strip()
                if theme in themes:
                    self.config['theme'] = theme
                    self.save_config()
                    print(f"✅ Theme set to {theme}")
            elif choice == '5':
                self.config = {
                    'default_provider': 1,
                    'auto_save_context': True,
                    'show_provider_info': True,
                    'theme': 'default'
                }
                self.save_config()
                print("✅ Settings reset to defaults")

        except KeyboardInterrupt:
            print("\n✋ Cancelled")

    def show_usage_stats(self):
        """Display usage statistics"""
        if not self.history_file.exists():
            print("\n📊 No usage data available")
            return

        try:
            with open(self.history_file, 'r') as f:
                history = json.load(f)

            # Count providers
            provider_count = {}
            for chat in history:
                provider = chat.get('provider', 'Unknown')
                provider_count[provider] = provider_count.get(provider, 0) + 1

            print("\n📊 Usage Statistics:")
            print("-" * 60)
            print(f"Total Chats: {len(history)}")
            print("\nProvider Usage:")

            for provider, count in sorted(provider_count.items(), key=lambda x: x[1], reverse=True):
                percentage = (count / len(history)) * 100
                print(f"  {provider}: {count} chats ({percentage:.1f}%)")

        except Exception as e:
            print(f"\n❌ Error loading stats: {e}")

    def run(self):
        """Main application loop"""
        while True:
            self.clear_screen()
            self.show_banner()

            # Show current status
            print(f"Current Provider: {self.config['default_provider']} | ", end="")
            print(f"Auto-save: {'✅' if self.config['auto_save_context'] else '❌'} | ", end="")
            print(f"History: {len([1 for _ in []])} chats\n")

            # Main menu
            print("Options:")
            print("  1) 🚀 Quick Chat (Default Provider)")
            print("  2) 🔄 Switch Provider")
            print("  3) 📝 View Chat History")
            print("  4) ⚙️  Settings")
            print("  5) 📊 Usage Statistics")
            print("  6) 💾 Save Current Context")
            print("  7) 🗑️  Clear History")
            print("  8) ❌ Exit")
            print()

            try:
                choice = input("Select option [1-8]: ").strip()

                if choice == '1':
                    self.quick_chat()
                elif choice == '2':
                    self.switch_provider()
                    input("\nPress Enter to continue...")
                elif choice == '3':
                    self.show_chat_history()
                    input("\nPress Enter to continue...")
                elif choice == '4':
                    self.show_settings()
                    input("\nPress Enter to continue...")
                elif choice == '5':
                    self.show_usage_stats()
                    input("\nPress Enter to continue...")
                elif choice == '6':
                    context = input("Enter context to save: ")
                    with open(Path.home() / 'claude_chat_context.txt', 'w') as f:
                        f.write(f"# Context saved at {datetime.datetime.now()}\n")
                        f.write(context + "\n")
                    print("✅ Context saved!")
                    input("\nPress Enter to continue...")
                elif choice == '7':
                    if self.history_file.exists():
                        self.history_file.unlink()
                        print("✅ History cleared!")
                    input("\nPress Enter to continue...")
                elif choice == '8' or choice.lower() == 'q':
                    print("\n👋 Goodbye!")
                    sys.exit(0)
                else:
                    print("\n❌ Invalid choice")
                    input("Press Enter to continue...")

            except KeyboardInterrupt:
                print("\n\n👋 Goodbye!")
                sys.exit(0)

if __name__ == "__main__":
    app = ClaudeMaster()
    app.run()