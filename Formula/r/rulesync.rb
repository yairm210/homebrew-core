class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.22.0.tgz"
  sha256 "2cee13e044c03df62d757425b7ce9516854ae6e6e007618403b05251a322abe1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0421eaaa44b4d35c6f8874b6e1ad018d92820ac558e410b51c9d0a54732fc47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0421eaaa44b4d35c6f8874b6e1ad018d92820ac558e410b51c9d0a54732fc47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0421eaaa44b4d35c6f8874b6e1ad018d92820ac558e410b51c9d0a54732fc47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064b6648af9dfd394c6678e97bdcc9642a0584c128de113ae86a4b279c59859f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064b6648af9dfd394c6678e97bdcc9642a0584c128de113ae86a4b279c59859f"
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
