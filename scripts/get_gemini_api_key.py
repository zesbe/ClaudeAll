#!/usr/bin/env python3
"""
Panduan lengkap mendapatkan Google Gemini API Key
"""

import webbrowser

def show_instructions():
    print("=" * 70)
    print("GOOGLE GEMINI API KEY - PANDUAN LENGKAP")
    print("=" * 70)
    print()

    print("CARA 1: Dapatkan API Key (Paling Mudah)")
    print("-" * 50)
    print("1. Buka link ini di browser:")
    print("   👉 https://aistudio.google.com/app/apikey")
    print()
    print("2. Login dengan akun Google Anda")
    print()
    print("3. Klik 'Create API Key'")
    print()
    print("4. Beri nama API key (misal: 'My Key')")
    print()
    print("5. Copy API key yang muncul")
    print("   Format: AIzaSyCxxxxxxxxxxxxxxx")
    print()

    print("CARA 2: Via Google Cloud Console")
    print("-" * 50)
    print("1. Buka: https://console.cloud.google.com")
    print("2. Pilih project atau buat baru")
    print("3. Cari 'Generative Language API'")
    print("4. Enable API")
    print("5. Buat Credentials > API Key")
    print()

    print("SETELAH DAPET API KEY:")
    print("-" * 50)
    print("✓ API key sudah disimpan otomatis di script")
    print("✓ Langsung bisa pakai opsi 2 di claude-all")
    print()

    return input("Masukkan API Key Anda (tekan Enter jika sudah ada): ").strip()

def save_api_key(api_key):
    """Save API key to file"""
    if not api_key:
        # Check if already exists
        import os
        if os.path.exists("/tmp/gemini_key.txt"):
            with open("/tmp/gemini_key.txt", "r") as f:
                return f.read().strip()
        return None

    # Validate format
    if not api_key.startswith("AIza"):
        print("❌ Format API key salah!")
        print("   Harus dimulai dengan 'AIza'")
        return None

    # Save to temporary file for claude-all
    with open("/tmp/gemini_key.txt", "w") as f:
        f.write(api_key)

    print(f"✅ API Key disimpan: {api_key[:20]}...")
    return api_key

def main():
    # Try to open browser
    try:
        print("Membuka browser...")
        webbrowser.open("https://aistudio.google.com/app/apikey")
    except:
        pass

    # Get API key
    api_key = show_instructions()

    if api_key:
        saved_key = save_api_key(api_key)
        if saved_key:
            print("\n" + "=" * 70)
            print("✅ SETUP SELESAI!")
            print("=" * 70)
            print()
            print("Sekarang langsung bisa pakai:")
            print("1. Jalankan: claude-all")
            print("2. Pilih opsi 2 (Gemini AI Studio)")
            print("3. Mulai chat!")
            print()
            print("API Key Anda:", saved_key[:20] + "...")
            print("=" * 70)

if __name__ == "__main__":
    main()