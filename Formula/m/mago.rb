class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.8.0/source-code.tar.gz"
  sha256 "6335655525cca4ab04260553401911a70bacd2f017c3e8374fc6228cdbc9ba50"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41fb0c22c2b31fe64fb2a777acb6bbfce1af7eafbe315ddec970e18c4b1a3b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357b4ba7d62920c7364c06d1cffe94d4dc212f6407859b30bcdc7e566069d640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f0f897beadf473e5340f93dca6a324922782000cd0715da94b534150445cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "41539eb37017dce1bdfa4000d00c79a390971109c698ee93dee3b6a5911f49dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a603d4722096844bce1fdc226c27c012089d7fcc6c2c3ceed830f1a5a7d317d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301862851abe7b644a78e6df150fa681babbb9857dba5225203b33f8772aafd8"
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
