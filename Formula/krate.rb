class Krate < Formula
  desc "CLI for the krate micro-VM platform"
  homepage "https://krate.sh"
  version "0.36.11"
  license "Commercial"

  url "https://github.com/krate-dot-sh/krate-releases/releases/download/v0.36.11/krate-0.36.11-arm64-darwin.tar.gz"
  sha256 "bdd8206599a111de0bc3f6efc4d8c502c28c60811abe50e49d14576587452b0c"

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
    <<~EOS
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
  end
end
