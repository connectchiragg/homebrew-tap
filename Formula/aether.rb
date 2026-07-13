class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.5.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.4/aether-aarch64-apple-darwin.tar.gz"
      sha256 "6573430488f10c2442b07998dfa84a725e60535b08ca1f3301d64bc6b84c1c94"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.4/aether-x86_64-apple-darwin.tar.gz"
      sha256 "148ff2de2f6789eb13c0b1e230f701b08d2ebc58a0449b31099cbba527e37d3c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.4/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6130512bd7fd3d0cc75d68c21b8844cc648a5223fbf730c81e0ee05a0a5b0dae"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.4/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7b9f51ea4028b8f7c85b7151ab647485940c57366a5aea00bd1fe81c51ffdcb5"
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
