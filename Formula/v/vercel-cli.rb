class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.12.1.tgz"
  sha256 "3beb5077f9e77cce8afed2fe463a000b520662cb706eaf7bae4b7c43b98796ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "958d01b1af96d64c9b50ac86f6bccc8bd330de2cdc2101a53312f429ce24e7ff"
    sha256 cellar: :any,                 arm64_sequoia: "d01a8411866a37271010d9ee42d069350295d7ffc65ca77bb75212513a344a01"
    sha256 cellar: :any,                 arm64_sonoma:  "d01a8411866a37271010d9ee42d069350295d7ffc65ca77bb75212513a344a01"
    sha256 cellar: :any,                 sonoma:        "fcf3cc7ae7cae122712380a09927ccc2bab3f033efabed9015d642e538d5aa5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60b1ea0f108eb4ef7c183fffb2783a4555b35a6f272dff3fbee221ab65f2c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df4db78539aa610c87d5eb60eda7fd2919ecc271592707271bc6ab1f1cea440"
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
