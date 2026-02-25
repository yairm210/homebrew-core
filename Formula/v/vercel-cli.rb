class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.23.2.tgz"
  sha256 "dd312e87eab119c6730c67da166b2afe5912c303df267c13a70034ffecfe3ba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "985000510b4301fc98178b6dba9568c4a230415cb83144b7294b477a88639fcd"
    sha256 cellar: :any,                 arm64_sequoia: "5cd6b5f02c13b58b94246bfab0b16b858ad8a7dce3a06ad450ffc9f1b8f20fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "5cd6b5f02c13b58b94246bfab0b16b858ad8a7dce3a06ad450ffc9f1b8f20fa5"
    sha256 cellar: :any,                 sonoma:        "389abcf8708e5ae72b354837d3f1fa6b4198f79b2cc3baaa8352f9d236e195ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f98b0e2d6ba8cdb2a6925b233907fd419ab187dcbf1a5d5114089eaa1dacff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec450508b8c9af92fd459f648c55c82c33cdc3c71e63fb60298969bd0efe926"
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
