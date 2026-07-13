class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.5.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.3/aether-aarch64-apple-darwin.tar.gz"
      sha256 "1b704f08146eca149078bde80c093ca0dc286b9f00582eedd6d9bd80ec59cc36"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.3/aether-x86_64-apple-darwin.tar.gz"
      sha256 "a99144e8f5d58a2772074b198847f13b199680d8efad5643777063052f6f9e03"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.3/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d08e736b1db0dc8dd2bf510fa679dabdcc9b26fc8eeb8b87f8d4064c0bdffa97"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.5.3/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b796d6e5d8eaad35a8079c309f106a328738e473899e0e98f3df2a1985f203b4"
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
