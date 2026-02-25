class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.87.0.tgz"
  sha256 "e047ba72154abca3aea63a1307514b71a570655d06ca4d661ad86fd4c9d87e86"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4594827e9ee48619073c9ce6a2fc0617711ca6018374143e63b82b0c2983fbcc"
    sha256 cellar: :any,                 arm64_sequoia: "b49d5018a84c27cb9876d8629a99261008bc71cb493095b5988d35325583c2d6"
    sha256 cellar: :any,                 arm64_sonoma:  "b49d5018a84c27cb9876d8629a99261008bc71cb493095b5988d35325583c2d6"
    sha256 cellar: :any,                 sonoma:        "ba725db36ba3709cb293c52fa360b5ac9fa4bf8db5c2394c44b18e837f9f2f93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b92495d4689259fdee921bf63bc57b01263c118da28740caef2fc8775b1e8d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4604bdcaeeb2c9644e5cc6aa6b0fefeb479b62931f298def2c1ecabe985a296c"
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
