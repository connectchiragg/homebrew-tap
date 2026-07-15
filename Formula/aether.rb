class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.6.0/aether-aarch64-apple-darwin.tar.gz"
      sha256 "82b175ef3374c014be4176f9c8264979d6fbd1960aee071ae20d1f041c7284a0"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.6.0/aether-x86_64-apple-darwin.tar.gz"
      sha256 "e89bea327b9af859d1da8de9fdb94e4b6982c85df0039b35dc222694f00ca8d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.6.0/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b20502a3d83c13b57b20614019d4069a28d08659c7bd46cb1d852dcf9be730a1"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.6.0/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a8b905a088a0df6a8d2185338711299ceb8260dc2d2376b4427ecc14ed5fc58c"
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
