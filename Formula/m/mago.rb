class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.12.1/source-code.tar.gz"
  sha256 "270c643c228787f733eb62bb82d67b637b825c22c0cf7720dd73b80601885def"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ec188d59d7a31ebbe959d72d72c977a09406b1b896309ec5f8df42ceb1bd7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f73e4c0148bfdf3d0afa42a3df1e4c59437416ca0b81471c1b84066fbec1d1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fcadfaa8869e25bd4c9e122a7c792353d3edd337283b517403e13696b7f2270"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f9b2136425a7e06ef42c47520553ca0fc60eccfa87e9f04aa6aa004a209bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ca639248a3439f55a8f2ec4fb3076b37b2cfc824c9ed075a4b1c6363e963af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a81ff959d278900a8a537218f89e753ccd3e5d10c797774a81f305ccc806fd"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
