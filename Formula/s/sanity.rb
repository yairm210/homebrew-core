class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.26.0.tgz"
  sha256 "a03b77b9bc7bd1ac08b87f1ad954acc36c859f7bac97b64cddbe87b16609e270"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "946b4caecdb449f95a1e009d50f5ea03ec857c3a36090a15a56e68a233da701e"
    sha256 cellar: :any, arm64_tahoe:       "946b4caecdb449f95a1e009d50f5ea03ec857c3a36090a15a56e68a233da701e"
    sha256 cellar: :any, arm64_sequoia:     "946b4caecdb449f95a1e009d50f5ea03ec857c3a36090a15a56e68a233da701e"
    sha256 cellar: :any, arm64_linux:       "f0f6c760254490ee0497586eebf850d40c250e3946353a19ff89c71821267c17"
    sha256 cellar: :any, x86_64_linux:      "6521c4ec853ea304298e6987e79b58c4732c76561a22a985216bdd68e0e9055e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
