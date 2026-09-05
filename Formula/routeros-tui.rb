class RouterosTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/routeros-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.9.1/routeros-tui-macos-arm64.tar.gz"
      sha256 "c86e0b801977822554acbd835744ec8b69e8f4f64c1f6331c5824dec006e7748"
    end
    on_intel do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.9.1/routeros-tui-macos-amd64.tar.gz"
      sha256 "0d334f53d3a272b363ac9c285dec47c94acc1cf1422b3921887c4e8b754a38ba"
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
