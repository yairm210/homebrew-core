class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/gnu/parallel/parallel-20260222.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20260222.tar.bz2"
  sha256 "c6272a48972a0f2fdd3f39560d698f3c5abd3d8a4de40d52f9772f3a03ae1f48"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b7f470b8d7176edb7d8401a9b6325ed6ba053a436aa45ef9ed4d148736b7329"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    ENV.append_path "PATH", bin

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install share/"bash-completion/completions/parallel"
  end

  def caveats
    <<~EOS
      To use the --csv option, the Perl Text::CSV module has to be installed.
      You can install it via:
        perl -MCPAN -e'install Text::CSV'
    EOS
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
