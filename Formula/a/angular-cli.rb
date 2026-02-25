class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.0.tgz"
  sha256 "c1aa16820c78dfd6cf01e1f4e70143a6c09543940744123f2caecf7752d9a931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0ce4d0eb83e837cb7957e0ac8c9718a1721f0c7d62b6cc16d14a56088f9ef2f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
