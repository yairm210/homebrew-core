class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.76.0.tgz"
  sha256 "32d7cafc513435e932d7ed286776f6826cc840a6cdff09f810332bcca06d2d0d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8be4e039eefec36248b06960ed5536593a855a1ac30d14422ac3a912c4a63e27"
    sha256 cellar: :any,                 arm64_sequoia: "b70fb550017b5643aa560c7e25d1eb72e8f73538002688862e987371668acbc8"
    sha256 cellar: :any,                 arm64_sonoma:  "b70fb550017b5643aa560c7e25d1eb72e8f73538002688862e987371668acbc8"
    sha256 cellar: :any,                 sonoma:        "f9a81faef795565b535b6250a4757c4a7c3520abb3bd27b96be2e0e158b7463f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a95127242851deac5b1ae640227253034ac9ac8779760c20f55ee2d43aebd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52b4aefdcab27c41a3cff39fd8d7ee819721503a4ff6ae3c23eb8611fa74f9a"
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
