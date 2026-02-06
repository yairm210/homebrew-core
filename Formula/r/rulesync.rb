class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.6.1.tgz"
  sha256 "c0335c7f3c5fe9184e1a7263eed9216484d80391ef92be537064d6752eb7f2cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "316badb584d9c753dbf7426a700891b946ac9608ca9f7b8cde4e64cd37efc7a5"
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
