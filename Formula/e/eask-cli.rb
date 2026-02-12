class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https://emacs-eask.github.io/"
  url "https://registry.npmjs.org/@emacs-eask/cli/-/cli-0.12.6.tgz"
  sha256 "51ea82efd3dbae6cd9689f5850c8895a7e2dccf6d16b942372c9f86e1036d656"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "790653f421ade6ddb718c1aa539224c340992f98edd188edd7e372586e3be956"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eask --version")

    system bin/"eask", "create", "package", "test-project"
    assert_path_exists testpath/"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}/eask compile 2>&1")
  end
end
