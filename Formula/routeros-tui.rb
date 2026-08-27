class RouterosTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/routeros-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.7.0/routeros-tui-macos-arm64.tar.gz"
      sha256 "e3a9674a1cce953bf0559c2d58e6c1f67eb730108ece72f9f6e1e3aee54d777e"
    end
    on_intel do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.7.0/routeros-tui-macos-amd64.tar.gz"
      sha256 "ac4f3908ab719975b9f3f11025d8c45c7166aaf8158db7f3ead7964ef0b85daf"
    end
  end

  head do
    url "https://github.com/hafuta/routeros-tui.git", branch: "master"
    depends_on "rust" => :build
  end

  depends_on :macos

  livecheck do
    url "https://github.com/hafuta/routeros-tui"
    strategy :github_latest
  end

  def install
    if build.head?
      rm "rust-toolchain.toml" if File.exist?("rust-toolchain.toml")
      system "cargo", "install", "--locked", *std_cargo_args(path: "crates/routeros-tui")
    elsif File.exist?("routeros-tui")
      bin.install "routeros-tui"
    else
      bin.install "mikrotik-tui" => "routeros-tui"
    end
  end

  test do
    assert_match "routeros-tui", shell_output("#{bin}/routeros-tui --version")
  end
end
