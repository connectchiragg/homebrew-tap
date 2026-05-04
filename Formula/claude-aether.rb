class ClaudeAether < Formula
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

  def post_install
    # Install Claude Code skill
    skill_dir = File.join(Dir.home, ".claude", "skills", "aether")
    FileUtils.mkdir_p(skill_dir)

    skill_content = <<~SKILL
      ---
      name: aether
      description: |
        Toggle live agent observability and per-turn quality metrics.
        Run /aether to toggle on or off.
      allowed-tools:
        - Bash
      ---

      # Aether — Live Agent Observability

      When this skill is invoked, first check if aether is currently enabled:

      ```bash
      if [ -f ~/.claude/hooks/aether-metrics.py ]; then
        echo "AETHER_STATUS=enabled"
      else
        echo "AETHER_STATUS=disabled"
      fi
      ```

      ## If currently ENABLED → turn it OFF

      ```bash
      [ -f ~/.claude/hooks/aether-hook.py ] && mv ~/.claude/hooks/aether-hook.py ~/.claude/hooks/aether-hook.py.off
      [ -f ~/.claude/hooks/aether-metrics.py ] && mv ~/.claude/hooks/aether-metrics.py ~/.claude/hooks/aether-metrics.py.off
      ```

      Print:

      > **Aether disabled.** Agent logging and metrics scoring are off.
      > Run `/aether` again to re-enable.

      Then STOP. Do not proceed to the enable steps.

      ## If currently DISABLED → turn it ON

      ```bash
      mkdir -p ~/.claude/hooks
      [ -f ~/.claude/hooks/aether-hook.py.off ] && mv ~/.claude/hooks/aether-hook.py.off ~/.claude/hooks/aether-hook.py
      [ -f ~/.claude/hooks/aether-metrics.py.off ] && mv ~/.claude/hooks/aether-metrics.py.off ~/.claude/hooks/aether-metrics.py
      ```

      Print:

      > **Aether enabled.** Per-turn quality metrics will be scored live.
      >
      > Open a second terminal and run:
      > ```
      > aether watch
      > ```

      Then STOP.
    SKILL

    File.write(File.join(skill_dir, "SKILL.md"), skill_content)
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
