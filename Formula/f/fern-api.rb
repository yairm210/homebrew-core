class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.84.0.tgz"
  sha256 "573acb4b2982c28cba1de7fc6ea9d1137934b59e77e97cb32cdba7a371a9570e"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70e5504221eb52db3aba94af67929f04d07b551725242b37576aaeacd70c04f5"
    sha256 cellar: :any,                 arm64_sequoia: "e519707ce05b2f990d6d2cae8c7f918efbe14439fbdc9fa97976215a340d5fde"
    sha256 cellar: :any,                 arm64_sonoma:  "e519707ce05b2f990d6d2cae8c7f918efbe14439fbdc9fa97976215a340d5fde"
    sha256 cellar: :any,                 sonoma:        "1323ceeb9a450af34e2d202399215c6f995636647e53e8e6f25d4b452e921a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c905519cab38d2f5e3bc6ce610ec3342a6b20100e8eb4b72869e411884d09ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd31670eb3136b5fc57ffa05ac1c36949b613a8e0b9eae4cb2eba4254f0b051"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
