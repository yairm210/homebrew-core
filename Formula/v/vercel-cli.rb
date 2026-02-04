class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.10.2.tgz"
  sha256 "4fd657c0426e820549f764bf107d4a4b5e643f6d4da9c806bd2489093ffc77f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b6a6672ecea25dc8edf173f1427bc943c88b99242269916be6160c1eb1ecb52"
    sha256 cellar: :any,                 arm64_sequoia: "2f410a4840552d9e611ca4f31fa149f5dd1ba117bc87ce45f4569bbfe0aed13a"
    sha256 cellar: :any,                 arm64_sonoma:  "2f410a4840552d9e611ca4f31fa149f5dd1ba117bc87ce45f4569bbfe0aed13a"
    sha256 cellar: :any,                 sonoma:        "16bfeb80b5662631d09ef798c3a6ee263695bc40d7e86789a186500a58d9f3bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c75056358c6ac78c1e284e0c287881970c768c218ebb0f8a3a7ea06dfbde8e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b931e38617ad8a655dfe1000c4231e2ab653c196528a1288669d1153a27b58"
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
