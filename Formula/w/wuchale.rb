class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.26.4.tgz"
  sha256 "7a0994fc1db1535531b321932122c57e6fecac7d762097ee9295184b0b66bc90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4bd7e91699c455a4f1339252109c5cb9796a56c5bedc8cdbeab861e1e5c74a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
