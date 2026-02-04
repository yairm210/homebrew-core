class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.10.0.tgz"
  sha256 "9ef03d9341c4896c7d8ba9b046bb691cbb7bceeb2681c8ecca9cab5f33d15181"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "311ae724f9092c52184f3db2884da109961fd34d9b85ab3966cf51beb68fc8f4"
    sha256 cellar: :any,                 arm64_sequoia: "00dd4ba4229d2ec08135f0780789eda698b16c7ff437c26e2ec3c4d042d79ffc"
    sha256 cellar: :any,                 arm64_sonoma:  "00dd4ba4229d2ec08135f0780789eda698b16c7ff437c26e2ec3c4d042d79ffc"
    sha256 cellar: :any,                 sonoma:        "a07279c50f12e07b681d12c27219bc16e9702a3cef95f379f7e6fc14a7bbd62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc94411fc13c5724dda3e97e40166d29670d255e6584c3a361663d4907fb2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053245030f611eba9be54f0ec02a5a333e5952bc23221c44d4e2a53ce8610f11"
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
