class ReadwiseCli < Formula
  desc "Command-line interface for Readwise and Reader"
  homepage "https://readwise.io/cli"
  url "https://registry.npmjs.org/@readwise/cli/-/cli-0.5.10.tgz"
  sha256 "43d0be21396b40766c834bd671b5b5ecc79b27d20766d7c16ee6e064191a6a5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe044c28473e69cdb20f70445fc0d10098ad4c267eb2eeebe60c068e43fec050"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/readwise --version")

    system bin/"readwise", "config", "set", "readonly", "true"
    assert_match "true", shell_output("#{bin}/readwise config get readonly")
  end
end
