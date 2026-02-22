class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.39.2.tgz"
  sha256 "8c6d6a2b4aa651c2569c15ec7105aaa99755340d0bbb08697b6ad2cfcb499b63"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c3dab6481ba197e1526af67ee8d4a88b0e1717cba6fac205c54e1d2c5e6a2772"
    sha256                               arm64_sequoia: "c3dab6481ba197e1526af67ee8d4a88b0e1717cba6fac205c54e1d2c5e6a2772"
    sha256                               arm64_sonoma:  "c3dab6481ba197e1526af67ee8d4a88b0e1717cba6fac205c54e1d2c5e6a2772"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbdec723ba7f76ecb8a5248f8bb41cdff60e0fa5ae6c47c965aa5ef93485d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd920e2e882bda0a5874f8f5a4dbb6f005efdae3543897df826546fa81c10030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db3e1086925fed6fce549496b435e2ec82194b46d31b8c6dac6afbd4d46e617"
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
