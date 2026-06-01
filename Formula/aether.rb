class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.5.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-apple-darwin.tar.gz"
      sha256 "52793a7c5fe2994bc4b1c5b5c025f3854546f40382175882196e015e5947f32e"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-apple-darwin.tar.gz"
      sha256 "a6cbb6fc39454d829ca930783332614949c7fd2be3c15a20356b77f416a1ae4c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11fb9653ba8f5a6b21f7a1e35e2dc3bcceb55fcfa2ecb007468083a364384a7e"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "70a7cb025b41d174f8b53f568ef3c90a9627edcc585e0011c0c272780db39c88"
    end
  end

  def install
    bin.install "aether"
  end

  def caveats
    <<~EOS
      Enable one or more providers:
        aether setup claude
        aether setup codex

      Then:
        aether watch        # choose a provider and watch sessions

      To clean up after uninstall:
        curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/uninstall.sh | bash
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
