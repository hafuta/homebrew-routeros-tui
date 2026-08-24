class MikrotikTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/mikrotik-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.5.0/mikrotik-tui-macos-arm64.tar.gz"
      sha256 "31426535c2f9f3252baae85f0dd3750d3b78af58456e9984f7f601f8a95d9639"
    end
    on_intel do
      url "https://github.com/hafuta/mikrotik-tui/releases/download/v0.5.0/mikrotik-tui-macos-amd64.tar.gz"
      sha256 "e1311bfd57673972e6b08e805eb94b77b21952cc43fac1399f9d4aa0174ef9fb"
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
