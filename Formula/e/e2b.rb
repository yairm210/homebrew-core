class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.7.1.tgz"
  sha256 "414ff0353d6594d1a1f418d561e6654488b3325cc00bed49b71669027fabe6e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e09b382e1e675408ea4830b958d8b5892846e209a9a172140a9f77b23b73a682"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
