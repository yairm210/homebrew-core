class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags/releases/download/v2.44/rtags-2.44.tar.bz2"
  sha256 "3db5b36216e0b0a98fa7ad1e03a29b2ca7c9d895d85dbe3b2760fcdc2f962db3"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v3.23"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0f4c862af37cbe89e0f60fe2bb5bba367d242053ec011806f2de77bd32f0c7b3"
    sha256 cellar: :any, arm64_sequoia: "d1e42fd3f0aeebb68b7433ec896d03289531d57e0d2aef125ad277fd60c96a8c"
    sha256 cellar: :any, arm64_sonoma:  "f44cb58558839fc5fb8d4e3e8d55444427d0e1f7f28e5433fb2095f88a6d47a2"
    sha256 cellar: :any, sonoma:        "178b1e30e3d0854dcd8efde6dc19a2e381758b8d827a149e002177c17816824d"
    sha256               arm64_linux:   "76894967e23dd4b2a84f244aa7a311186f3acfcc8b2282f6a77f41c7815dbb96"
    sha256               x86_64_linux:  "56ab5c0cbde519576bfd1bb1ab97822a4002aa946ece1b4ee9df2a0fe00b855c"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"rdm", "--verbose", "--inactivity-timeout=300"]
    keep_alive true
    log_path var/"log/rtags.log"
    error_log_path var/"log/rtags.log"
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<~C
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    C
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = spawn "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log", [:out, :err] => File::NULL
    begin
      sleep 5
      sleep 10 if OS.mac? && Hardware::CPU.intel?
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill "TERM", rdm
      Process.wait rdm
    end
  end
end
