class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.14.1.tgz"
  sha256 "6c5263e67307dbdd3009a7c8764421a627578e3469aa96114ab67d06a574c285"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc88abe74413c0228c371c7070c5fceb85cc4a8206febf6f96bd7da5aeb06645"
    sha256 cellar: :any,                 arm64_sequoia: "21ad7bc4a625e95b1c4ff1417d252d517766a221b497c50fa43449e763b2c94f"
    sha256 cellar: :any,                 arm64_sonoma:  "21ad7bc4a625e95b1c4ff1417d252d517766a221b497c50fa43449e763b2c94f"
    sha256 cellar: :any,                 sonoma:        "cc4315ddefbf56c4610826c139a7e73bbf5ae823ba82df980656b2cb135ae252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ae485acad7a272f59f33717faf0fa50e102ffb82ec2aa75c56fdac87758315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2654a1011b0a0b71d213c901b98b2157f91f4a2c8da5c6e766fad3d39e5c111a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
