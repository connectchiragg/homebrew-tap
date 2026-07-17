class Aether < Formula
  desc "Live observability for coding agents"
  homepage "https://github.com/connectchiragg/aether"
  version "0.7.0"
  license "MIT"

  bottle do
    root_url "https://github.com/connectchiragg/aether/releases/download/v0.7.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03dab450e992080667b8fe05a91dfa74197b600bfd6ea40563459e07335dabac"
    sha256 cellar: :any_skip_relocation, sequoia:       "362cae0829ca327580000167b22433becea7557355d3b3742d75e728fe620e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55779c4f83ae3331f0a63c8eca1b11219047e6844d90029cc1c1c516b70dfb1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179676dbf95bf978f200efdecd891ea4b0ecdbc43d2f3fea16de11ccab1f7221"
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.0/aether-aarch64-apple-darwin.tar.gz"
      sha256 "f09867d65fafe9ca3a497dbc6a67743b5ca90c7d719f1b94b28ef36cb20cc833"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.0/aether-x86_64-apple-darwin.tar.gz"
      sha256 "aa7b628508544974251fae47bbaebd2f2dee88b6c217c412db3e8b06915e8336"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.0/aether-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "216dfeeb3f0364567bf4bbcb2dc31184c546a36e744a1c2f7a45501241940bed"
    else
      url "https://github.com/connectchiragg/aether/releases/download/v0.7.0/aether-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "660bb8b7e4188e95fc9e373fe745c7d10e720acebb9007ce92c3d209395d0470"
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
