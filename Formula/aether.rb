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

    # Install setup script that user runs once
    (bin/"aether-setup").write <<~SH
      #!/bin/bash
      set -euo pipefail
      GREEN='\\033[0;32m'
      BOLD='\\033[1m'
      DIM='\\033[2m'
      NC='\\033[0m'
      info() { echo -e "${GREEN}${BOLD}==>${NC} $1"; }

      info "Setting up aether for Claude Code..."

      # Skill
      mkdir -p ~/.claude/skills/aether
      curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/.claude/skills/aether/SKILL.md \\
        -o ~/.claude/skills/aether/SKILL.md
      info "Skill installed"

      # Metrics hook (inactive)
      mkdir -p ~/.claude/hooks
      if [ ! -f ~/.claude/hooks/aether-metrics.py ] && [ ! -f ~/.claude/hooks/aether-metrics.py.off ]; then
        curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/.claude/hooks/aether-metrics.py \\
          -o ~/.claude/hooks/aether-metrics.py.off
        chmod +x ~/.claude/hooks/aether-metrics.py.off
        info "Metrics hook installed (inactive)"
      fi

      # Register Stop hook
      python3 - ~/.claude/settings.json << 'PYEOF'
import json, sys, os
path = sys.argv[1]
settings = {}
if os.path.exists(path):
    try:
        with open(path) as f: settings = json.load(f)
    except: pass
hooks = settings.get("hooks", {})
stop = hooks.get("Stop", [])
cmd = "python3 ~/.claude/hooks/aether-metrics.py"
if not any(cmd in h.get("command","") for e in stop for h in e.get("hooks",[])):
    stop.append({"matcher":"","hooks":[{"type":"command","command":cmd}]})
    hooks["Stop"] = stop
    settings["hooks"] = hooks
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path,"w") as f: json.dump(settings, f, indent=2)
PYEOF
      info "Stop hook registered"

      echo ""
      info "Setup complete!"
      echo -e "  Run ${BOLD}aether watch${NC} to start"
      echo -e "  Type ${BOLD}/aether${NC} in Claude Code to enable metrics"
    SH
    chmod 0755, bin/"aether-setup"
  end

  def caveats
    <<~EOS
      Run the setup script to install the Claude Code skill and hooks:
        aether-setup

      Then:
        aether watch        # in a separate terminal
        /aether             # in Claude Code to enable metrics

      To clean up after uninstall:
        curl -fsSL https://raw.githubusercontent.com/connectchiragg/aether/master/uninstall.sh | bash
    EOS
  end

  test do
    assert_match "aether", shell_output("#{bin}/aether --help")
  end
end
