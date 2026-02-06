class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.12.3.tgz"
  sha256 "79f36dc74e6250c8736e44deaf8f26ba1982e92582e0b3d9d4dc839087937f53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7319b3771ef40442fc40f8909ab63144304d290987409547d3290a0b67781357"
    sha256 cellar: :any,                 arm64_sequoia: "2d01982fa5a3fd7b5a9cc5cfb2872477c4f257ac7f54687296a6ef89c0e40d62"
    sha256 cellar: :any,                 arm64_sonoma:  "2d01982fa5a3fd7b5a9cc5cfb2872477c4f257ac7f54687296a6ef89c0e40d62"
    sha256 cellar: :any,                 sonoma:        "a8ee1e71bc58afc093b446aae5c98325dc660dc4926243a997c509ddea0b5834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba747570dc7d11751015c29060501fa1c85c4147cf2372aedc1491111a7413a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44fddbead6f9eb70f6ca7b886f1f0a107fa8c17206d09b93634e1ee8cd94985"
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
