class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.22.0.tgz"
  sha256 "1b67edc2d0deb01019303a06f5b9cc9878200114be61f1c325787b6ec03995e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "969ed0110b4a89daad1f653b5f6566bfd534aff7eaa044a5139ce64d8a4ec91c"
    sha256 cellar: :any,                 arm64_sequoia: "587cc44ffe46f5395803b77a0057b33e333f81dff3067b256976af8610db729e"
    sha256 cellar: :any,                 arm64_sonoma:  "587cc44ffe46f5395803b77a0057b33e333f81dff3067b256976af8610db729e"
    sha256 cellar: :any,                 sonoma:        "b94f2220b45106bc88cf7038f817d431b55128aba581787d6e053ad2ef8b0508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6db74491065a14d8802e57ba281f2c34f172624515224594b89ee5f59fcd942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9f9cb6a209e14c47aa618dc53b423e6c66eca2d82c278f1294df7320cf070a"
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
