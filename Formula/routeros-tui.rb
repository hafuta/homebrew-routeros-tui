class RouterosTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/routeros-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.9.0/routeros-tui-macos-arm64.tar.gz"
      sha256 "d76ad2ec300bec6c41bde00cbbf2eaa9b3c803fc727ea08faf6bc3b7b138030a"
    end
    on_intel do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.9.0/routeros-tui-macos-amd64.tar.gz"
      sha256 "f6f137b17ad58114dd332eb58b6a351375ad5ac82835d1a3df71987af2631d65"
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
