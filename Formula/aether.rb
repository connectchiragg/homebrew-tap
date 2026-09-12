class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.7.2"
  license "MIT"

  bottle do
    root_url "https://github.com/connectchiragg/aether/releases/download/v0.7.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c38e8d00b0b0bf39f051f051cd8c5f986098ea0a76b1e377d77d208af657363"
    sha256 cellar: :any_skip_relocation, sequoia:       "92fdbf2bd44d6c7ebe1ad94c981185bde253dba5fb491ef3492373d8b6dbd609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b476eb305d6c044f59934fb917bd4935ffaff762cb5716341cf44dc603e994b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe2b8e35c120c25c03ab30f227e493e4cede5fb3e3b6f9927283fff328575d8"
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.2/aether-aarch64-apple-darwin.tar.gz"
      sha256 "987e653ff68211ad4977fe2ccd45a62363ffc2adca1a17cb35b11a264db576ef"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.2/aether-x86_64-apple-darwin.tar.gz"
      sha256 "9c425a16255151a2d825b0cc0556e01686c31b3cf62457a3e688ad52c3838a9f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.2/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5cd3ff401e1fb6feffcd34e82054e07f72d9df3ea1f4d0e660d6d3b009b3a9a8"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.2/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "75579666f6cf7671f285151c619282c9ec113a410f779895233c629890ce079d"
    end
  end

  def install
    bin.install "aether"
  end

  def caveats
    <<~EOS
      Start Aether:
        aether watch

      Uninstall:
        brew uninstall aether
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
