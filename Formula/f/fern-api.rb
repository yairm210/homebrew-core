class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.55.0.tgz"
  sha256 "9a4f7a46df5c8f96ff2471b1f59b21947a227fd7542c737b2683ccb602a9ac92"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74ede749713aceb1c543db0dd50e7236b524e007b0831e4bc82fb8a20441e4f7"
    sha256 cellar: :any,                 arm64_sequoia: "72516ec317ca46397b3e36b6aac87ebb19f600edf11d90d5ce1a9370d79f8f83"
    sha256 cellar: :any,                 arm64_sonoma:  "72516ec317ca46397b3e36b6aac87ebb19f600edf11d90d5ce1a9370d79f8f83"
    sha256 cellar: :any,                 sonoma:        "2f619585e7ef6ed6ffd80b4b39e0e89e26f0f15aba23eede6b20cbfb038eceb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7fcf9e5ffc2a57f82651d7c7a81328e2596165190a7b5689a9d2f8920d07dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54a9519a7d2f18069b7d8b6c4bc60d4947805a6376a96e2d48c0a9ba1cf7881"
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
