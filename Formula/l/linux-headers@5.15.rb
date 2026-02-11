class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.200.tar.gz"
  sha256 "f6f41c3821b3996d5911c03d57f65aa2128cd6526f725489618bcc76dc9b2a6c"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "155a601e7494f54b09e05a24d4ff8e189c80a69ed54d87d4f2c73d7cc7253abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c48ef5eacf0091b4172514ed3902058a4653dbeb5e2e37aa706dda72ed60eb3"
  end

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
