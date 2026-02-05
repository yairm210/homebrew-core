class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://github.com/npm/node-semver"
  url "https://github.com/npm/node-semver/archive/refs/tags/v7.7.4.tar.gz"
  sha256 "2072cbab721596665f4015d155fec333fbe8c7a261437bb8b1cbe2b8fa42d17a"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f020cebec97e076cc18178823c6c8011f0f40d28e8e49e086ebb4782ca9379f6"
  end
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semver --help")
    assert_match "1.2.3", shell_output("#{bin}/semver 1.2.3-beta.1 -i release")
  end
end
