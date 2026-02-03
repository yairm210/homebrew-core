class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/26.01/MediaInfo_CLI_26.01_GNU_FromSource.tar.xz"
  sha256 "3e70f27783521c31d6e852bd1982cb8858b9633982b66967a56d5364fb856de3"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df64ac24effddaa3c65a7de6ad1f3c5dbcc0b2b421158c7697d7cbd5f9863729"
    sha256 cellar: :any,                 arm64_sequoia: "0350cd8e8ef91d2a66e3cb80b792b57e44a732f3ee1e196b8dab5a08020db66e"
    sha256 cellar: :any,                 arm64_sonoma:  "c8baf13eee9f5ab31e28239c7c3561acdba34b737f90104a71fd56c7839a8b8f"
    sha256 cellar: :any,                 sonoma:        "1e7500b0d156317e49f42db0dc0212d281664a65e103d2e78e22f683100d62e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0ed043bb76004670f1a9cb27733de7626845c4f48829eaf66d38324e2d3507e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ce248d29cf45aea2642c1524f2800a0f43822e1c0012f195a052a29c507203"
  end

  depends_on "pkgconf" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end
