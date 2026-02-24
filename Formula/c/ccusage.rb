class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.7.tgz"
  sha256 "1ea795f9733cb01da125db4c42f5f318253f9a41f506dd6e9c4a16e15ce10a42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "513cb25bee6ccf74ee0645433e5d509d884b36efe307fe671914db12d1b400c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
