class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.18.1.tgz"
  sha256 "b6a7ea6034fb05358d0c7f990d851b03c48060fd5c1444aee414ccb50180a886"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acd54788a1797741556f39ef14d9dd521957074b236056bfc23d65d4bcad398b"
    sha256 cellar: :any,                 arm64_sequoia: "f98a6faa9f2183f0964e5b6755523511deeac240f01f73fcf839c780e740508c"
    sha256 cellar: :any,                 arm64_sonoma:  "f98a6faa9f2183f0964e5b6755523511deeac240f01f73fcf839c780e740508c"
    sha256 cellar: :any,                 sonoma:        "add199c0d545b260279cb740de854a272045c0c23d236a2ae27717b0189ab1de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98dbd1ca90ab2f57990cfc6cee9e9dad1c177e8ba78aeb4f3f9126f3c9457b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7034aa3ca657bb58a1ac871ca837df8440cefcc5119abd2244ad30bf7fff9fea"
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
