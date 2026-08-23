class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.1.5/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "52da45aecc8ece659f128161fd3be1df05b90236ac0403f7c87b76cb6a7a6430"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.1.5/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "e0ab86ad3d8c6c45915e3bb7b74f8bd095858b8f0faead6f71d60deac27fe02c"
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
