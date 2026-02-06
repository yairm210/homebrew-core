class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.13.1.tgz"
  sha256 "49104fe0d5c87ec4500ae58a44076635a4d309fda4dc82283639ef2d3b84661a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bafceaca008a9a2ce8f78c93bb8218ef4d6a52ae0e1727ff66aadd2b52cd457"
    sha256 cellar: :any,                 arm64_sequoia: "5554ab5564724a86969ffc33a54575ad6951012c2fa8747cbfaf6ebfe09d309d"
    sha256 cellar: :any,                 arm64_sonoma:  "5554ab5564724a86969ffc33a54575ad6951012c2fa8747cbfaf6ebfe09d309d"
    sha256 cellar: :any,                 sonoma:        "404cce148574ab3e561c4d37da2530f3c7e0de89a5db616b308023d085c8237f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b253b358cb327486422577bc266e59e1fe267696ee6327c6014964f8e9c809d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5fc1d5b6ebcc6255cf33219ff7f359aec9612c6b84119d66532182cb64b9aae"
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
