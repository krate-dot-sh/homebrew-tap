class Krate < Formula
  desc "CLI for the krate micro-VM platform"
  homepage "https://kannister.app"
  version "0.36.1"
  license "Commercial"

  url "https://github.com/kannister-app/krate/releases/download/v0.36.1/krate-0.36.1-arm64-darwin.tar.gz"
  sha256 "d9c256bd09a67c5a3427a691edfbac1c37dca2a1fc5f59e0424a2129f3739d14"

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
