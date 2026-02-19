class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.20.3.tgz"
  sha256 "2c4ad2664690bda434f742f6da5c0462f82116958377beaad833345e595016c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9d43db9a829f9f7175165e0b394985371e0ad4376026a8922d237ac5e0db636"
    sha256 cellar: :any,                 arm64_sequoia: "a9cc73f74cc72dd8710cf777dae8df24f50e919c5b017648d49736ccf9e3b481"
    sha256 cellar: :any,                 arm64_sonoma:  "a9cc73f74cc72dd8710cf777dae8df24f50e919c5b017648d49736ccf9e3b481"
    sha256 cellar: :any,                 sonoma:        "849101b9af2022f924c52ab43684ae0ac228671624b574042680ae4634b1b482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650ad629c3589013931cd09b603da9045cfd3837d5f45c74936a80f5cc077ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ef23098aa8d1dd446c42826358fbd0ab880e701bf5ac97a32f10b9cea077d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/neonctl/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
