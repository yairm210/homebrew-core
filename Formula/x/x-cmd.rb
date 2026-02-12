class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "b9fad6d78f7b4b06cec132d5a68b71016780a4b1c340ba483141990608432e59"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a66dc64ff0d704a55ff52fb6713ddfce8b0000b6e39ecbd11afb27f95bcc208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a66dc64ff0d704a55ff52fb6713ddfce8b0000b6e39ecbd11afb27f95bcc208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a66dc64ff0d704a55ff52fb6713ddfce8b0000b6e39ecbd11afb27f95bcc208"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c858b87dda117421f2c6b97f8e94b31707e3f0f3f3e6addbf1b204593ad8b52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79c3bd459ddf3201de33e5c8e45ff6d1ca8a630fd5ce11647159433305cb084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79c3bd459ddf3201de33e5c8e45ff6d1ca8a630fd5ce11647159433305cb084"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
