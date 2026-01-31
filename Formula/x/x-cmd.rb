class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "b33cdbc509370861009215bafcef68ddc3d9c3090c5f9c407a7015541e6ea334"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "697c1398f0b789b0d6e32d769b6c21ed434828306db70e38efca79f27666f44e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697c1398f0b789b0d6e32d769b6c21ed434828306db70e38efca79f27666f44e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697c1398f0b789b0d6e32d769b6c21ed434828306db70e38efca79f27666f44e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7af7aa6ebe508d3d1796e8f4b2321ed0b6d0453365539a1ec6e76b216a3e239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3ed3d896f8b673cb73cfcf23cfe07a4bab45a441ee3e13885f21476b2ad00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3ed3d896f8b673cb73cfcf23cfe07a4bab45a441ee3e13885f21476b2ad00c"
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
