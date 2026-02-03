class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1210_SDK.zip"
  version "12.10"
  sha256 "c898154b99ea8f9ae0bcfc98270fcb21a2ff1fce543ca267dadba05995079fde"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "025039c141d4020aee52cf4dafeb0571642edd7abf0c58d2a4f9b4092d98b025"
    sha256 cellar: :any,                 arm64_sequoia: "7710fb6d10b15ac98991c3e7163e5395a388f40da4c56bddedf69f27dc24bf1c"
    sha256 cellar: :any,                 arm64_sonoma:  "1fb5a574f4db257eb3acb467c4e9286aace563f793ca90de668a00f5ae99534a"
    sha256 cellar: :any,                 sonoma:        "c2e48606fa9cdb815e6847cd2baceb4b01b71d0b136abbe91ba9996be8d0c098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2b921acc2421086b865a3d357cb70e7a22823a549f5f7a5b0baf9cbfd757d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10220c5ace1cfdbae96f44e1a0aa9266ddd1d4491170167dd253f76c6118774"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
