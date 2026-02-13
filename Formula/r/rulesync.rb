class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.1.0.tgz"
  sha256 "80dffe28410b557a95089294b56e63f3e1c59f633f484a13e2e63f8da8acbb2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0b8b5739b3f1b4dddd379273325e22a2a4b07fbf185a4b63d4d59e09f6b3b09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
