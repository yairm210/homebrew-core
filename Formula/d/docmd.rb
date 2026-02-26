class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.9.tgz"
  sha256 "0c80fe7712b31acb402e18da6d82d16d3c255ed51ab5f50159b29db7581a109a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "211d4b356b50daac7ebf6af2f1fa737e19060919ddcb0a67f81604dde1e0ab11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f85d46467eb895b93da8263aaf4871855099a979316d61e5e90ec8ad2337cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f85d46467eb895b93da8263aaf4871855099a979316d61e5e90ec8ad2337cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6f478f9da14cfd87376acda1e6da9dc67f3d9f900b219076db6ad47676f472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ef6bac683d4f4a277b1160ec6184f0b434b487071d6b220a309170ea9cd74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afa1ff7afe8d212d1b5d0ce5df70f40bcf2a2caf931dcfa9ef588f7c83a1976"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
