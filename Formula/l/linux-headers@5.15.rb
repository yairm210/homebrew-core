class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.199.tar.gz"
  sha256 "8c6cf28bc5f735bd92c85834ccb5efd9bd514f7c8e66ce84c8b0d11e0f0f326e"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ae220908ac54ee539f436eeec9c7e5dcc9c9a23cf0aa67eceb21a0108c8472a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a23cc17be361b119de034a4591327deedea52bca20af79b963f5e2511455838f"
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
