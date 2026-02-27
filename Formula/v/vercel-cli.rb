class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.2.tgz"
  sha256 "86083a4d3972699a3f79dabd6434630360877ab1909c41223c55e738c309ed47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9625f416f4c0c6101c6a133572af1ffc59b4d8ba6e90ee3820b89010e75f67ba"
    sha256 cellar: :any,                 arm64_sequoia: "aed3ca266badc628c37305e1e703ee3bc6989ac1575400c37c6fade24b75fae4"
    sha256 cellar: :any,                 arm64_sonoma:  "aed3ca266badc628c37305e1e703ee3bc6989ac1575400c37c6fade24b75fae4"
    sha256 cellar: :any,                 sonoma:        "342757a86fa8b6f076dc02ece8e689c573b26f14b517b63374294b04f39da912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cdcc102d8eb7b172504b7abed6eb2b3abdbe13ef7979874e5b2375e51fe30ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814a7d218ca2c0d74b2a7387a6f7d9a2313c75c1891ccaab18b3a51282b68722"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
