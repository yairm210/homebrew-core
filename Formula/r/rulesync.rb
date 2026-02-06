class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.6.2.tgz"
  sha256 "a05d9ad7ba57e684104a727225ed1821bf52d4a0f6851f62e7dcc6953d6bff29"
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
