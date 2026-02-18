class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.0.1.tgz"
  sha256 "f406e92811cd7e618a8d23a096cc1c6ed0dbe8127f4571eaf75cc7fecbd403d1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c7409b854faf6fb50f59136e95ea0da3df2a2a84b5c52046160792b64fc797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a0abbe4b7acfcd22dafdccb29a7e261215824c544d69f7fe8388cce30f8d9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a0abbe4b7acfcd22dafdccb29a7e261215824c544d69f7fe8388cce30f8d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc43177472915e895c8e87b97985820bbebba924f1f8cca7db1ea5aee8cf1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58f8f2a16b8b6d6e490ad53c6dd065ed5fb8e1981e4d5d3447bb3642f4a6c71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786c80527bae04006c14f7137e08655ed9f2d4991de49ab1bc521c221cbbb664"
  end

  depends_on "node"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
