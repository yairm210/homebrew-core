class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.67.0.tgz"
  sha256 "f1b5648bc896ec344097bc8adbe8533ee42b95a696ae037b0b6e5e25e745b59d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6440e93a584bb597bcf4137eb01a7e8ce393aaa942f6e14f377d34416f9dcd9"
    sha256 cellar: :any,                 arm64_sequoia: "6a0a5d8fff8a1e0ac8cd3f59ef3ee08648e6a38497add267eb27b170a8802292"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0a5d8fff8a1e0ac8cd3f59ef3ee08648e6a38497add267eb27b170a8802292"
    sha256 cellar: :any,                 sonoma:        "4aa5f6f6fe3da105e235fc6b040e47452ec2e5d09c62c2203ebc9297e9231711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0be69c2ed59b6f21816aab70141a22074fca34829f6b1321602f79561b4e2bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c1df196932181c71bb7a517abdd21ac79e6e4bacfc586c5049ceadbe498e7b"
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
