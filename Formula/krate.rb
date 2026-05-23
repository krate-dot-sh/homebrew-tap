class Krate < Formula
  desc "CLI for the krate micro-VM platform"
  homepage "https://krate.sh"
  version "0.36.10"
  license "Commercial"

  url "https://github.com/krate-dot-sh/krate-releases/releases/download/v0.36.10/krate-0.36.10-arm64-darwin.tar.gz"
  sha256 "b5435e9587bf7313a833a0ae44106d52e8db7960570bc98cbfd8bb4166c8dde8"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "krate"
    bin.install "krated"
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
