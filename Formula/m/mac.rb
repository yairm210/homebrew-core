class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1233_SDK.zip"
  version "12.33"
  sha256 "9c9e5a091d37bf6ec074ce988137a93765ef1ebe76e9e85f35e853a675903147"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "520622a4d513bdeede6858fc2570caa849a7b9e71e0ea1195c2fc2fa51a5d573"
    sha256 cellar: :any,                 arm64_sequoia: "ce9774df87b003093c576be1d3c9a3b2c961c1887f94d550cc876275a77cbbfc"
    sha256 cellar: :any,                 arm64_sonoma:  "494f9845077c15b1389f32f8309f7cb41b23eb04b89fd904b93edcf724dc7c51"
    sha256 cellar: :any,                 sonoma:        "c4712e7a274fbf27ca8821cfab7835518365af131d7c925c8eb1c3ae0327bb9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ffae34ebf010f3bd671ccb6a216f407582336b87c5e21500509e220823b2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe46b664060e40188ff5e7174c0f766c92116d9b8ca69e8aeece573f749b2c7"
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
