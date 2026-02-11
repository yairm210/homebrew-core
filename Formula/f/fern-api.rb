class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.73.0.tgz"
  sha256 "05024308a8b4086183514b09021866be233a0b1792122ae81ecffe17dede87ba"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "067c6ed4d349065ad85d56012eb26a3db8efad0936de824012d0f6bc63606b1d"
    sha256 cellar: :any,                 arm64_sequoia: "2fe08e952835b35866994164e362dd4df0205da6f58e60861977f501635fbfeb"
    sha256 cellar: :any,                 arm64_sonoma:  "2fe08e952835b35866994164e362dd4df0205da6f58e60861977f501635fbfeb"
    sha256 cellar: :any,                 sonoma:        "a888d60dfa4cba8b44fe39f6d0e4db53e45ae9a9f9b9c87fd03009d313ff2594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4a340a791d2e5822f829f2d2a43ef9d201df12ecfd0e873390e136c376add78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76c440029967d019cb894e9c2c6685ec8bd0d48f13fc2ccfe387778d1b56f03"
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
