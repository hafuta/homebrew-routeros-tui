class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.4.0/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "68a02890dd7b52a0d7cec64078119e097bcfb9e2ad6bb745d6aef19388ef5a78"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.4.0/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "7f38dfac418f8203954f8b03ec0ef17e2ee02e182b64dd890892e2b0bef7534e"
    end
  end

  head do
    url "https://github.com/hafuta/mikrotik-tui.git", branch: "master"
    depends_on "rust" => :build
  end

  depends_on :macos

  livecheck do
    url "https://github.com/hafuta/mikrotik-tui"
    strategy :github_latest
  end

  def install
    if build.head?
      rm "rust-toolchain.toml" if File.exist?("rust-toolchain.toml")
      system "cargo", "install", "--locked", *std_cargo_args(path: "crates/mikrotik-tui")
    else
      bin.install "mikrotik-tui"
    end
  end

  test do
    assert_match "mikrotik-tui", shell_output("#{bin}/mikrotik-tui --version")
  end
end
