class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.5.tgz"
  sha256 "6be35fd7714a1e81d8f04e6272c0e744efaa7b3bc1690924711e26b4e6d757d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d44a8e9a1400c8164dc955ab645d0c8ee317aa8aa28f067398c8b0698cf06c56"
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
