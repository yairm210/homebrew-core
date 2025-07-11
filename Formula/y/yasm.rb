class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  # Actual homepage shown below, but currently unreachable:
  # homepage "https://yasm.tortall.net/"
  homepage "https://www.tortall.net/projects/yasm/manual/html/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    :public_domain,
    any_of: ["Artistic-1.0-Perl", "GPL-2.0-or-later", "LGPL-2.0-or-later"], # libyasm/bitvect.c
  ]
  revision 2

  livecheck do
    url "https://yasm.tortall.net/Download.html"
    regex(/href=.*?yasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "45b7744e4f66670c270ac4aa64836625a1806db9ac97920476620d340cbbdd96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8201d94c49a9f010d7b7fa185eb2658484ed9d063b0334baff12659bebb22246"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59763588b57923ad20c8090a7382aa361efc2503ad788dae648c95f24f410a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1a844ce9a26db6d2a5c72dbced52b7fbfc8491bfde95a2f026eaa1e46433be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "398b7f3d8a22e43b5af2335fe2d39448a3e9cc7a769ef1faf60c25fda0873d50"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a459b8a128c82d79a253c164b213a4483c81ded729a4958be000da17b64b893"
    sha256 cellar: :any_skip_relocation, ventura:        "2cfb5f1ab641c6537a73570eef6ec14bf9f5bbd31d8c1dcc3f8a7233b880df09"
    sha256 cellar: :any_skip_relocation, monterey:       "8348a13c38c499aa114f71e4d46f311105b68dbafbf0e92f6c19d5b492eed569"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca95cb3c02508796ff4e60d54146b03016b93e80837916359912ebf737a37562"
    sha256 cellar: :any_skip_relocation, catalina:       "9aa61930f25fe305dc5364e72f539b0a225702b5f1dc222a9dde1216e901f7ab"
    sha256 cellar: :any_skip_relocation, mojave:         "0dc797b72ee3bad9c6a52276c871ac745207b5626722e805fa642d7a872847fc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7f31deeff91c5929f2cd52eca6b636669f9c8966f6d4777e89fa4b04e541ad85"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "915dcddbe7d3b6c170b8055d3f1fbea22fb80fa1a6ca1f0c2876d52cabb2b4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d46adb6213bba936b7d62ef9564f752cc5b4268e19e91f0b67e136408ab30e"
  end

  head do
    url "https://github.com/yasm/yasm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-python
    ]

    # https://github.com/Homebrew/legacy-homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"foo.s").write <<~ASM
      mov eax, 0
      mov ebx, 0
      int 0x80
    ASM
    system bin/"yasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code

    if OS.mac?
      (testpath/"test.asm").write <<~ASM
        global start
        section .text
        start:
            mov     rax, 0x2000004 ; write
            mov     rdi, 1 ; stdout
            mov     rsi, qword msg
            mov     rdx, msg.len
            syscall
            mov     rax, 0x2000001 ; exit
            mov     rdi, 0
            syscall
        section .data
        msg:    db      "Hello, world!", 10
        .len:   equ     $ - msg
      ASM
      system bin/"yasm", "-f", "macho64", "test.asm"
      system "/usr/bin/ld", "-macosx_version_min", "10.8.0", "-static", "-o", "test", "test.o"
      assert_match "Mach-O 64-bit object x86_64", shell_output("file test.o")
      assert_match "Mach-O 64-bit executable x86_64", shell_output("file test")
    else
      (testpath/"test.asm").write <<~ASM
        global _start
        section .text
        _start:
            mov     rax, 1
            mov     rdi, 1
            mov     rsi, msg
            mov     rdx, msg.len
            syscall
            mov     rax, 60
            mov     rdi, 0
            syscall
        section .data
        msg:    db      "Hello, world!", 10
        .len:   equ     $ - msg
      ASM
      system bin/"yasm", "-f", "elf64", "test.asm"
      system "/usr/bin/ld", "-static", "-o", "test", "test.o" if Hardware::CPU.intel?
    end
    assert_equal "Hello, world!\n", shell_output("./test") if Hardware::CPU.intel?
  end
end
