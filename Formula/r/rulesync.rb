class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.9.0.tgz"
  sha256 "a0ed992b4175a57feb841f041031776bf238aa834ddc2381762eebdd67375468"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c686d76c8d3135a7a17704f588965bf4bb7f7690a1d2240d2d2778787ff895d7"
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
