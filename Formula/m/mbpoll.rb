class Mbpoll < Formula
  desc "Command-line utility to communicate with ModBus slave (RTU or TCP)"
  homepage "https://epsilonrt.fr"
  url "https://github.com/epsilonrt/mbpoll/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "a9bcc3afa3b85b3794505d07827873ead280d96a94769d236892eb8a4fb9956f"
  license "GPL-3.0-only"
  head "https://github.com/epsilonrt/mbpoll.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a8e9a61b04c4c4b18a0af7c86006612b40949b381fba4cd0342cb0cf073245"
    sha256 cellar: :any,                 arm64_sequoia: "f2e1b7cc1e13adec4be27c0786d6d58d8452981695981111b9fb5a27b4209672"
    sha256 cellar: :any,                 arm64_sonoma:  "38fed0cebc17a0f5b56f57c877ba9aedb7740f88ad49ec8b7ab20b75d46d451a"
    sha256 cellar: :any,                 arm64_ventura: "11ad727f1304188c6973eeb682de71cf60275cda1cc2055564454dcfa03eb264"
    sha256 cellar: :any,                 sonoma:        "448753a6babe4e91ec293111c781deca8456740af65c153c09b3a7f334d7ef8f"
    sha256 cellar: :any,                 ventura:       "18d5251c8aa33916193ca6023807ba57a335f0abc5c2109fc7ff9921a3b69cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e6297dc717b70f1c464440d12ca264392b9b87bfee6a33e61f14d1579c80fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dffd6e9a6cbca3f5950ea1fd49d0db7ca5cf0d7a117faac986a1c2bbe43cff49"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmodbus"

  # fix missing INT_MAX/INT_MIN definitions, upstream pr ref: https://github.com/epsilonrt/mbpoll/pull/105
  patch do
    url "https://github.com/epsilonrt/mbpoll/commit/8a8bd34d803ef8f4daa5aad13eabbe838e2f3fad.patch?full_index=1"
    sha256 "9c663ed9c66e6c62423957a2f19f0916d3ff577433f06f088b721db62c6c080b"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # NOTE: using "1.0-0" and not "1.5.2"
    # upstream fix pr: https://github.com/epsilonrt/mbpoll/pull/58
    assert_match "1.0-0", shell_output("#{bin}/mbpoll -V")

    assert_match "Connection failed", shell_output("#{bin}/mbpoll -1 -o 0.01 -q -m tcp invalid.host 2>&1", 1)
  end
end
