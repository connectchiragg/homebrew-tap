class Aether < Formula
  desc "Live agent observability for Claude Code"
  homepage "https://github.com/connectchiragg/aether"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-apple-darwin.tar.gz"
      sha256 "632acf887d932b29e8e6a6d0f092873f3b07d86d1b3d9387361173ca521d73d9"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-apple-darwin.tar.gz"
      sha256 "d179f806575f562f6fa5105f46826dcecf8cb495e90c78189b7cd84638b6a2f2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "71f70b493fe344b4420318a837699cb2683ed90c15fd7c660f44c674cc790158"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e808b3478213f2c372a15904de75afb990b8523088a676e452d0fe05f83bb880"
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
