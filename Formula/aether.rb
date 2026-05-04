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

  def post_install
    home = ENV["HOME"] || Dir.home

    # Install Claude Code skill
    skill_dir = File.join(home, ".claude", "skills", "aether")
    FileUtils.mkdir_p(skill_dir)
    File.write(File.join(skill_dir, "SKILL.md"), skill_content)

    # Install metrics hook (inactive by default)
    hooks_dir = File.join(home, ".claude", "hooks")
    FileUtils.mkdir_p(hooks_dir)
    hook_off = File.join(hooks_dir, "aether-metrics.py.off")
    unless File.exist?(hook_off) || File.exist?(File.join(hooks_dir, "aether-metrics.py"))
      system "curl", "-fsSL",
        "https://raw.githubusercontent.com/connectchiragg/aether/master/.claude/hooks/aether-metrics.py",
        "-o", hook_off
      FileUtils.chmod(0o755, hook_off) if File.exist?(hook_off)
    end

    # Register Stop hook in settings.json
    settings_path = File.join(home, ".claude", "settings.json")
    register_stop_hook(settings_path)

    ohai "Skill installed to #{skill_dir}"
    ohai "Run `aether watch` to start, then `/aether` in Claude Code to enable metrics"
  end

  def caveats
    <<~EOS
      To start observing Claude Code sessions:
        aether watch

      To enable per-turn quality metrics, type in Claude Code:
        /aether
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end

  private

  def skill_content
    <<~'SKILL'
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
  end

  def register_stop_hook(settings_path)
    require "json"
    settings = {}
    if File.exist?(settings_path)
      begin
        settings = JSON.parse(File.read(settings_path))
      rescue JSON::ParserError
        settings = {}
      end
    end

    hooks = settings["hooks"] || {}
    stop_hooks = hooks["Stop"] || []
    metrics_cmd = "python3 ~/.claude/hooks/aether-metrics.py"

    already = stop_hooks.any? do |entry|
      (entry["hooks"] || []).any? { |h| (h["command"] || "").include?(metrics_cmd) }
    end

    unless already
      stop_hooks << {
        "matcher" => "",
        "hooks" => [{ "type" => "command", "command" => metrics_cmd }]
      }
      hooks["Stop"] = stop_hooks
      settings["hooks"] = hooks
      FileUtils.mkdir_p(File.dirname(settings_path))
      File.write(settings_path, JSON.pretty_generate(settings))
    end
  end
end
