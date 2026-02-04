class LibnetfilterConntrack < Formula
  desc "Library providing an API to the in-kernel connection tracking state table"
  homepage "https://www.netfilter.org/projects/libnetfilter_conntrack/"
  url "https://www.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-1.1.1.tar.xz"
  sha256 "769d3eaf57fa4fbdb05dd12873b6cb9a5be7844d8937e222b647381d44284820"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html"
    regex(/href=.*?libnetfilter_conntrack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e1c3d0f17c63a78eae6ba07fdf7cff0414dc883c3dc78495d5c1dddc3ca66c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae07370b1802d6089195cb605b4010635126ca6f6f37d20023c5f19ff9b833e6"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libmnl"
  depends_on "libnfnetlink"
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    pkgshare.install "examples"
    inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
  end

  test do
    flags = shell_output("pkgconf --cflags --libs libnetfilter_conntrack libmnl").chomp.split
    system ENV.cc, pkgshare/"examples/nfct-mnl-get.c", "-o", "nfct-mnl-get", *flags
    assert_match "mnl_socket_recvfrom: Operation not permitted", shell_output("./nfct-mnl-get inet 2>&1", 1)
  end
end
