class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.2.2/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "0b1f67278afafd6eab9683db1c3c14ceec4729a473583ca93cde0ea5e108c3c2"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.2.2/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "413b678b5aa16a125609577c92c719d6faea06272b49dd16e102bd772eaab3a3"
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
