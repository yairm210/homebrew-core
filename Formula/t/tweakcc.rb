class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.4.tgz"
  sha256 "0a69ccf3a348cc40ded52d3be78557f4196a34e6c6ef65f4a9f37e6397a6fc26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26fdc9392dc778c6700d4c55b11845f18b3526888618ef4100dc7785ad3afad0"
    sha256 cellar: :any,                 arm64_sequoia: "308cc16eb61d71de76301193b7ff9e2f40fde225fe7471af3704a020740691d7"
    sha256 cellar: :any,                 arm64_sonoma:  "308cc16eb61d71de76301193b7ff9e2f40fde225fe7471af3704a020740691d7"
    sha256 cellar: :any,                 sonoma:        "1b89170f87b5b6b22cdb8ea925b5278a59249638c75d55783c9842656169fc23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "066c77f63c2b6732b06d08b31d73ae544ef5ff96193120de749baa463ad784be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f88b7fb3e59b6c2d74b7815f668a8e6e52536adfd8b19fa7dcaec21a742d86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    node_modules = libexec/"lib/node_modules/tweakcc/node_modules"
    prebuilds = node_modules/"node-lief/prebuilds"
    prebuilds.children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "#{os}-#{arch}"
    end
    rm prebuilds/"#{os}-#{arch}/node-lief.musl.node" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
