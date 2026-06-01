class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-apple-darwin.tar.gz"
      sha256 "15f019a0a57f944e30d98dab074521f34e22e50046a33964586e03364b55ac57"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-apple-darwin.tar.gz"
      sha256 "ebab11ae6e69e36c4bc702f48e1b38f00894a6c89208f44cfad64d27fdd8399e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "77db63d7506be2dd2b4fc9bc62048c099196e2942d671c61fb9848be9ee3be07"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ad5f2166aafd8c217c0d6908b0fcd4c3970a2de623fe3d30cc7d070a135ff951"
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
