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
    sha256 cellar: :any,                 arm64_tahoe:   "820cc6009140df316e05e3ea45ea9e1c582ce5e4e6c914dff7c0adbe07fefa50"
    sha256 cellar: :any,                 arm64_sequoia: "cef99a0c168a629a4ea6ed85bc000fbe220cecf0a938e39f7c002e9c7630e4b0"
    sha256 cellar: :any,                 arm64_sonoma:  "cef99a0c168a629a4ea6ed85bc000fbe220cecf0a938e39f7c002e9c7630e4b0"
    sha256 cellar: :any,                 sonoma:        "aaa5ef7ef4c148ad186764c471a33261b5e63f607114f3d634016af36a4e52bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22c6c79e13c085af2f983ebe711c10f051fbbd512381af420737a09e08346ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0d7518049d4d1f92e654d8ea4ca937417b102d4bde0d8245e0eb3829b7a657"
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
