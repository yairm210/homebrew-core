class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-12.3.0.tgz"
  sha256 "0e3a43694c4a1104c82f4fc50ffa696a0bc7e3c0f311cc3d65894ab0985d13b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a4152f91350fecfcf5ca7c27e43de490d6dc826643a358b9fe87114727df4ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumpp --version")

    mkdir "repo" do
      system "git", "init"
      (testpath/"repo/package.json").write <<~JSON
        {
          "name": "bumpp-homebrew-test",
          "version": "1.0.0"
        }
      JSON

      system "git", "add", "package.json"
      system "git", "commit", "-m", "Initial commit"

      system bin/"bumpp", "--yes", "--push", "false", "--no-commit", "--release", "patch"

      package_json = (testpath/"repo/package.json").read
      package_hash = JSON.parse(package_json)
      assert_match "1.0.1", package_hash["version"]
    end
  end
end
