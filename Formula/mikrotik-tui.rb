class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.3.1/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "4dad05caffb5c592c134116c9963aab2c1b28c6bbeec88b2b6835ec9c90fc4ff"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.3.1/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "28b479420203992d1d66530b4e1043a8067a98f62451bdc4c6a505993418074d"
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
