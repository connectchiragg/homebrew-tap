class Aether < Formula
  desc "Live agent observability for Claude Code"
  homepage "https://github.com/connectchiragg/aether"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-apple-darwin.tar.gz"
      sha256 "f6139d51f6cc941fcf5d024c1f2b76ebf514dcd5a8ec86a9ada34055c910c685"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-apple-darwin.tar.gz"
      sha256 "06fb53974710a1388f4b0a750ab825e0aa0f7700aad4f731c3297ac9a10cdae1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "872b136a89f5067487e3a10e2ecd2e7026ac76936833b51cfd9a28e372136a23"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v#{version}/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "164f96ea5bdce050f3a0a6019f57b09d9b9ecc95473d6ca91a2fecabb42b3a08"
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
        aether              # start watching sessions
        /aether             # in Claude Code to enable metrics

      To clean up after uninstall:
        curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/uninstall.sh | bash
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
