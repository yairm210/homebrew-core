class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.20/psysh-v0.12.20.tar.gz"
  sha256 "2c411b65e83397e966519871e70e8e14aa7d6b2187a9e833a3d42422ac002e7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72b5d2f0e496899672ffac06ff0ab7574e6faf470f6ba1e516ef66d0986601c8"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
