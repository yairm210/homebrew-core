class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.19/psysh-v0.12.19.tar.gz"
  sha256 "30e280ec05a6e6a46d960e247afd0bff04a8cd988ed284fcc494fdbeebaf954a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "619f5c3a9dee0b21bfd71f7959f842d868a5bab5f2372612239248ffb9cc5e22"
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
