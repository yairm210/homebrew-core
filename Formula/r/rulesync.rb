class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.6.1.tgz"
  sha256 "56e7a75b4b0fbb60eaa9d3dd108c2b29ca235c8bce9f07dba479cc9199a31a77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d40ed8bfeb777bd92485422c2eb33588ec2323401bf6bf1507fb9a784a36990"
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
