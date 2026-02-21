class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.38.1.tgz"
  sha256 "312a236b4e9ec5b02110d0014b61ea3e500d84b1da51aa64713e32ed2cd9ce96"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "79b05457fcca62220f5d36abbc5d409a934d8309eade1acd30520edcf19b6ebb"
    sha256                               arm64_sequoia: "79b05457fcca62220f5d36abbc5d409a934d8309eade1acd30520edcf19b6ebb"
    sha256                               arm64_sonoma:  "79b05457fcca62220f5d36abbc5d409a934d8309eade1acd30520edcf19b6ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e567abbbd7ccf66c5f1a5adbad90144f7331241f0c1e9c6275bacfc3e9aff94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b6078acee3dcc972e8761bed0437a297436a0b88a363dc21b25c0ef79654810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b4c39ce2e1262ef90dc96128da3382836774a1ac8fce1d3aea7a0eb2ba8936"
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
