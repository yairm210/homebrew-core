class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.39.1.tgz"
  sha256 "55f413254e76e31a39cce22176487c56dbd4777c37377c215eb5aab7112a3208"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "73fcc518681ec6435eafa8c80c4e30be7d1624e3235530b2c3c606c5f5e90766"
    sha256                               arm64_sequoia: "73fcc518681ec6435eafa8c80c4e30be7d1624e3235530b2c3c606c5f5e90766"
    sha256                               arm64_sonoma:  "73fcc518681ec6435eafa8c80c4e30be7d1624e3235530b2c3c606c5f5e90766"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfc0d6dceb808c7de87818fee15c3f96fb920fa49059eee3bf8123c4985bec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1f1e09a658a1ac0584ae152aa181b579acc29a257be7ec51cb31a4a6354a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539a1ee78a8e9a40e0c7fa46beed66b2c18fa80f1624ab0ec2b6dad4de5f282f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
