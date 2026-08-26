class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.6.0/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "05915123ba381749be8c04193d6ee457ed57d1e13cdfd14bc2d9633c5b195a24"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.6.0/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "f2c1733e2f3a78de6eb070817cea2b4474c1898acdcac179a03368022cfac72a"
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
