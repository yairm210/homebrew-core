class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.6.3.tgz"
  sha256 "5571bc7ca24ff6fe3fe4e25c01a6af0b86ba0c05e43b826ea4c47e777315aa6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f01fb24bae26d44b9b2ed214b889251998bccffdefe6119b3d4494a31efe84fd"
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
