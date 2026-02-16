class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.9.tgz"
  sha256 "bb319a1c96097c80618c54f0790d23877420e4a16e87dc7e706f023667e62ca9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d85d59676207788506c24bf9a6a2a71cc4d1b0ee1ad179a56d28a629ee2388b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
