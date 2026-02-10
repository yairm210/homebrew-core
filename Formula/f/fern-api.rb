class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.72.0.tgz"
  sha256 "8e86482482e07c02016aed0a4503e569f35374ddf3b82b0e385ea606717d4122"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47c4db86e1048b6285f906231fd5553a24b2d68fdc92555356ffe228f3f92479"
    sha256 cellar: :any,                 arm64_sequoia: "9647f1f65c7285defa9caa15dee4c9b0b1c02724e3973efe7c16a9721365f9d8"
    sha256 cellar: :any,                 arm64_sonoma:  "9647f1f65c7285defa9caa15dee4c9b0b1c02724e3973efe7c16a9721365f9d8"
    sha256 cellar: :any,                 sonoma:        "fd62d76b99b0494f872944fa3eb9c627dc4525d329b4b6a7683021621b2edbce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419b62b3d106be29c6bd831445066d983ce1181a9e3963baafd89c0ee4140510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733a54da93bb23e2878b87e18aafd264c0bf0acad6a2583d077e2d2ff619cd77"
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
