class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.7.1"
  license "MIT"

  bottle do
    root_url "https://github.com/connectchiragg/aether/releases/download/v0.7.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26aea0648c2ac6793064d7c55585aa29cef7d7e5f960ce9dcdea46990fe42817"
    sha256 cellar: :any_skip_relocation, sequoia:       "eba20771621061d7d852b9a728f4987daeed901cf535946c28a3cf616499fc62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b45990962d085462005c429daa7270019ecc999c7ab370f1fee1ceeb62f1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ae66d679fde6b4be4822e77b35ce594c86bc2018145eb3c2d56488dc303309"
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.1/aether-aarch64-apple-darwin.tar.gz"
      sha256 "07aa557271bcac5a169f5ca8f3bf1760da5aa33f6b6e3b6e8a30ef124d9720e5"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.1/aether-x86_64-apple-darwin.tar.gz"
      sha256 "9dea539e47272cfb1b082aa28e8c8ce0a039206e28dabb52dd1be21c81262098"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.1/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b411fec81d63aedcd773ddcf5b99f8288ebe6d70a4fba93a32a2e28947bbb1bc"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.1/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfde0ff0dc3494810c5f3651c27823311bec35d402f23b8132aad3acc43d4b6d"
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
