class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "1c4faedd3dc95a643859e56cfe885f86e8189107995ab0b1eb2a64c433f95965"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f137fd883cb9693c6402de64fb581f0945c2f2109ac879ae66f925fff0ee1d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f137fd883cb9693c6402de64fb581f0945c2f2109ac879ae66f925fff0ee1d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f137fd883cb9693c6402de64fb581f0945c2f2109ac879ae66f925fff0ee1d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b21c57059ecc294faa55af9fd37e908a556dd8dd482a7478335f8a92cd6b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae47e5d1d13f1b8b1f613cfb3d7c2d6b3689b26a8f7913f27993f56ec802a1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae47e5d1d13f1b8b1f613cfb3d7c2d6b3689b26a8f7913f27993f56ec802a1ad"
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
