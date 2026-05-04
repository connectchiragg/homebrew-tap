class Aether < Formula
  desc "Live agent observability for Claude Code"
  homepage "https://github.com/connectchiragg/aether"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-apple-darwin.tar.gz"
      sha256 "25131979f1bba5991fb5442a4ed646cc4ddf14403c6ea7c8a85942b86004ccf8"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-apple-darwin.tar.gz"
      sha256 "fe473914b842e601a6714c9abd621a5628fa45b98460d0cd20d1197b0717b338"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c1ff8f5d31d0ca034fad674568b05dfd620f58a8dcf3808b4e2a73427b0f0b38"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af48b62bba86b6b075033a79aa5c572bd194f2de38e6ebc6626224ec0329b4cc"
    end
  end

  def install
    bin.install "aether"
  end

  def caveats
    <<~EOS
      Run setup to install the Claude Code skill and hooks:
        aether setup

      Then:
        aether watch        # start watching sessions
        /aether             # in Claude Code to enable metrics

      To clean up after uninstall:
        curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/uninstall.sh | bash
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
