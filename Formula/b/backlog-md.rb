class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.39.0.tgz"
  sha256 "8ac13d6a0f31e9d7e08ed4865abc3123a8a47008ad1d14c8f3808c9616ed3079"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b317d2a36c891fa4c31abe9a4390c123f1c46651cd30e8b2cdf821c49aef0208"
    sha256                               arm64_sequoia: "b317d2a36c891fa4c31abe9a4390c123f1c46651cd30e8b2cdf821c49aef0208"
    sha256                               arm64_sonoma:  "b317d2a36c891fa4c31abe9a4390c123f1c46651cd30e8b2cdf821c49aef0208"
    sha256 cellar: :any_skip_relocation, sonoma:        "0659989e55e59a79657f797d74b89e74f1f1e96961f868586b0f38158c2bf96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29b6fd53652bc97b17bb0d7dd091bfa5c93b7dd481f4b792ee4720ca4517a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accd872c082130eb1b850b1b177cb39732f47239da4c719c0551417fc3b57910"
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
