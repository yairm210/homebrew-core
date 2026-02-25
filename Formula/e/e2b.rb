class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.7.2.tgz"
  sha256 "ecf625b0c223b5ff0a10b85c3e2dd0553e65c73ed92552d2fe9a5c2ac6ec6988"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52d2d891ae9c7644aaa37d8738c490188e572c6bc3cedcc75afb34244d5b2dbf"
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
