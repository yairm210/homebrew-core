class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.47.5/source-code.tar.gz"
  sha256 "5e5ad69284aa8655309e29f95b5de03169340198900b4722226deec98787469c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c66edce30bdb5394527e42549dd968ae1836475dda308560f644a942d00b774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28cf308850552b3ac969a539169705eb11150d475c5fe6c2b730985b518447e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f475c36be6ef8515a178a32bb615cb6f7f0f42d936b3b9e2a081a41325021d5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b56304063eb8ea9a56e38b1e663719bbeeab377a41ad3b890f27b28341fb3087"
    sha256 cellar: :any,                 arm64_linux:   "78b15142aa0ead2fad449757f27d141d6355175eb578b541a92fc8f2b286a91b"
    sha256 cellar: :any,                 x86_64_linux:  "4cc20308b36c4079cb6c6ebc44db4d1dbe5439be29ae9811ab9f5e123093db08"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
