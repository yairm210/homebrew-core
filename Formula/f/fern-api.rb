class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.114.0.tgz"
  sha256 "f0a1e28c75db907e2581a08da1773c9f0a80a8993e1503a2d336b2ea77ec05a5"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3c04c6fe4fbbf29faa3463c0ebd56f4e91423c3dec3fe805817ec95d0c8ffef"
    sha256 cellar: :any,                 arm64_sequoia: "d3c04c6fe4fbbf29faa3463c0ebd56f4e91423c3dec3fe805817ec95d0c8ffef"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c04c6fe4fbbf29faa3463c0ebd56f4e91423c3dec3fe805817ec95d0c8ffef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94a9a385dc9f563036224ac1b80c165de626dfe364ce107ff0ddbe916b1655d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d7846a97f4032b40a95bc181e1802efd38e38de0b83d650bc3cf2b0468498e"
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
