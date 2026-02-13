class SssCli < Formula
  desc "Shamir secret share command-line interface"
  homepage "https://github.com/dsprenkels/sss-cli"
  url "https://github.com/dsprenkels/sss-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dd8232b11d968df6f1e21b2492796221a0fc13ee78d99bc2e725faf11159798f"
  license "MIT"
  head "https://github.com/dsprenkels/sss-cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    secret = testpath/"secret.txt"
    secret.write("secret")

    shares = shell_output("#{bin}/secret-share-split --count 10 --threshold 5 #{secret}")
    result = pipe_output("#{bin}/secret-share-combine", shares)
    assert_equal secret.read, result
  end
end
