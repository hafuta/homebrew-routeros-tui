class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.2.0/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "a1db668bf5df1630d67e23e71eddac8e4cb70bf1e37f1bd4802fc4e2cc7becef"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.2.0/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "53cc4b10d06e759799a599ac1837933eb41633e800c0428a44ab7e0faff5876a"
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
