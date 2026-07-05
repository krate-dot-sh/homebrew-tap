class Krate < Formula
  desc "CLI for the krate micro-VM platform"
  homepage "https://krate.sh"
  version "0.36.21"
  license "Commercial"

  url "https://github.com/krate-dot-sh/krate-releases/releases/download/v0.36.21/krate-0.36.21-arm64-darwin.tar.gz"
  sha256 "c7903d1920af21a27e0514db8f7856ccf157bf89adbd0ce12c6ed923db5157d1"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "krate"
    bin.install "krated"
  end

  # Kill any running krated after install. brew upgrade overwrites the
  # binary on disk but the running process is still the old code in
  # memory — a CLI/daemon version mismatch causes subtle bugs (stale
  # protocol handling, missing fixes, errors that don't carry the
  # latest error-chain plumbing). The daemon auto-restarts on the next
  # `krate` call, so killing it is silently self-healing.
  # `|| true` because pkill returns non-zero when nothing matched,
  # which isn't a failure condition.
  def post_install
    system "/bin/sh", "-c", "pkill krated 2>/dev/null || true"
  end

  def caveats
    base = <<~EOS
      Test the install:
        krate run hello-krate

      Log in to your krate account:
        krate login

      Check configuration:
        krate info

      VM debug logging (recommended for dev work):
        echo 'export KRATE_VM_DEBUG=1' >> ~/.zshrc
        source ~/.zshrc

      With KRATE_VM_DEBUG=1, every VM writes a forensic transcript to
      ~/.krate/logs/<workload-id>/ and stays open after the workload
      exits so you can `krate exec <id> sh` to inspect a broken VM.

      No manual daemon management required.
    EOS

    # GitHub transparently redirects kannister-app/homebrew-tap to
    # krate-dot-sh/homebrew-tap (same backing repo). So both tap names
    # install the same binary, but users on the legacy tap name keep
    # the stale "kannister-app/tap" in their brew config forever. Detect
    # via `self.tap.name` (returns the URL the user typed) and nudge
    # only the legacy-tap users to switch — krate-dot-sh/tap users see
    # nothing extra.
    legacy = (tap && tap.name == "kannister-app/tap") rescue false
    return base unless legacy

    base + <<~LEGACY

      ────────────────────────────────────────────────────────────────────
      You installed krate via the deprecated kannister-app/tap. This tap
      is being phased out (the krate-dot-sh org is now canonical). Please
      migrate so future upgrades keep working:

        brew untap kannister-app/tap
        brew tap krate-dot-sh/tap
        brew install krate-dot-sh/tap/krate

      Your installed binary is unchanged; this is a config cleanup only.
    LEGACY
  end
end
