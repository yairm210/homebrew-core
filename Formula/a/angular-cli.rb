class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.4.tgz"
  sha256 "d21850263e97c18f96efd50048033e780c3a644123ff12f0375df14f59b4bfe1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "468bfb843db4ee65440ba67edf5d87c777325a604a36868fb6dec3da74053789"
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
