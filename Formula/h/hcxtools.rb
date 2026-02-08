class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/7.1.2.tar.gz"
  sha256 "c726b93df32efd3298874b324f820d93cb08a4dae03d9144b0d5062c003fd77f"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52e91e41876ee0dace50f0eecf11e2965392d923f71f7ecc30c5d2db5cc36818"
    sha256 cellar: :any,                 arm64_sequoia: "6008c4a7f571ac3c6aa8c9918b7aaf271a0d326d2485a5cec997639c65f84421"
    sha256 cellar: :any,                 arm64_sonoma:  "41e97db33cb0569ebf7a54eb8bcee7f8c47212070bca6e04a5e1f37c1dd42922"
    sha256 cellar: :any,                 sonoma:        "0b28402dcf12d4782cb1d776f644cd5b447752c9fb836a67beb27c4b580855eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b10c6fb4b2966edcaebb7cdcd8824f5af6e3894df88a6dd657c8e7f3852ed469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847d5a2c07f77a76524ceaf988f34e2050381a28128a065a11a718fafa1a9620"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system bin/"hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system bin/"hcxpcapngtool", "-o", newhash, testcap

    expected = "WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***01"
    assert_equal expected, newhash.read.chomp
  end
end
