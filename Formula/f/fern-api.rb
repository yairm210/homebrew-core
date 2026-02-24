class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.86.0.tgz"
  sha256 "9364b5ba7715b4925ffd8fed6b2237ef9fd2b59e3b79c18db31c9eabbcc3fc88"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db8ff6569fb39a450a13ab0e310a136e4fa8cf72f3ac3605758017fd11495a93"
    sha256 cellar: :any,                 arm64_sequoia: "28516819a1e05da80990028d73550953b2b0ab084341cd37b99b0a4d2ad0835c"
    sha256 cellar: :any,                 arm64_sonoma:  "28516819a1e05da80990028d73550953b2b0ab084341cd37b99b0a4d2ad0835c"
    sha256 cellar: :any,                 sonoma:        "bc42e97c765084d026c49ffc91f7fafb6b5ec8b4a137824e2dc57b66f7160e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7929fe2f28bd191f374992b112457ab587c5020c13bbc38dc50c78b74f024915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef02f88c7471a1b7c2d3a58e8bf680adc6c606a9c70617abf0a0662360d38ff"
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
