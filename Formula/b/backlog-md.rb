class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.37.0.tgz"
  sha256 "d87c9a9e30baf1bd7e37d2356e97360ea0c821c9f46666dfe44c113a5e4e6320"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8b3e6db5e327183f91199d3d4cc35dcc8dd670031add2cdd9e3ead4007d2c49d"
    sha256                               arm64_sequoia: "8b3e6db5e327183f91199d3d4cc35dcc8dd670031add2cdd9e3ead4007d2c49d"
    sha256                               arm64_sonoma:  "8b3e6db5e327183f91199d3d4cc35dcc8dd670031add2cdd9e3ead4007d2c49d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8684bc2febf4f948eba2b70a5e204a38060261a135dbdd71d066764c98daa722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90fc8cab0a5db811fa07e73317037aa0d99fa8d35743234d3db3a45e5dbc458c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86d8b2bc4fd4d2f3983520038a0e961fd1c553680d64bb6a57fbce56feab79b"
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
