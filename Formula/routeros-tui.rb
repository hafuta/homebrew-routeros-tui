class RouterosTui < Formula
  desc "Keyboard-first terminal client for MikroTik RouterOS"
  homepage "https://github.com/hafuta/routeros-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.8.0/routeros-tui-macos-arm64.tar.gz"
      sha256 "499f68ef6f37e060d6b60421809fe994678ea8789ea293713a4cf40de60abe4f"
    end
    on_intel do
      url "https://github.com/hafuta/routeros-tui/releases/download/v0.8.0/routeros-tui-macos-amd64.tar.gz"
      sha256 "5d4ccc54c5da9049aa3b68c82999c3c552d54e9b68be4a51502a9bd70719cc08"
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
