class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz"
  sha256 "f8c3486509de705192138b00ef2c00bbbdd0e84c30d5c07d23fc73a9dc4cc9cc"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "fd614919e82580434f0f863552635bc0a152e48991694b4a2cfeac8fa04b0d1f"
    sha256 arm64_sequoia: "e569d99fb1824b0d14f1b895f34dec152c508155a7c5df851221eeb23e860544"
    sha256 arm64_sonoma:  "0325a0e84e37ea644f401028f83c77543043a71c9b399f06196d8e54b3053363"
    sha256 arm64_ventura: "c8c30a7f85b8cd20113553af345316cea62fcb3c3f138b624b4dba985aad7275"
    sha256 sonoma:        "60b126aaed8aa96bad8d7a0f487331c6abbfabcbeeddb503fefc5c95526c2547"
    sha256 ventura:       "83b3a81e89196364ceadf92485d06a5184b37529b5627b4fbe6ae87594be5181"
    sha256 arm64_linux:   "f7cae3224ad92248271e79d6ece078fef89f4b0092171024764e625a1a62be90"
    sha256 x86_64_linux:  "4fbe2760d1ce897fdf6726b2af2ecdaebbaa25d348e93e2dd2b4c270da71cee5"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    conflicts_with "awk", because: "both install an `awk` executable"
  end

  def install
    system "./bootstrap.sh" if build.head?

    args = %w[
      --disable-silent-rules
      --without-libsigsegv-prefix
    ]
    system "./configure", *args, *std_configure_args

    system "make"
    if which "cmp"
      # Cannot run pma tests in Docker container due to seccomp needed for personality syscall
      check_args = ["NEED_PMA="] if OS.linux?
      system "make", "check", *check_args
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (bin/"awk").unlink if OS.mac?
    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "awk" has been installed as "gawk".
        If you need to use it as "awk", you can add a "gnubin" directory
        to your PATH from your ~/.bashrc and/or ~/.zshrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
