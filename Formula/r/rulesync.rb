class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.6.2.tgz"
  sha256 "36e7a22b2a81c5c2592a6164e8607c5a3756b382eeb1385c4df47372d9908623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c29fe301fc557bc9306fd8a001d32c9d6ea2b1e931529f621c83274279c8886"
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
