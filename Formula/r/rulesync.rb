class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.7.0.tgz"
  sha256 "6db825268695f10656abb85d4e47a086d1bd421fad56cbbfe932087f1b4f5c3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b471c30aa0f2f273180e2ad964689a25b0f2e441576369a80d86279a9fc80a8"
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
