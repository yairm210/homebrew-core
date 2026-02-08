class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng"
  url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/archive/v1.1.5/qrupdate-ng-v1.1.5.tar.bz2"
  sha256 "d81523077586fec9dc26585c82a6c9c109f912f29d5ec9097822faf56297c4d2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "06f87282b23c5f3cec4efedea8259122807837de4e2fa0928ca380a69357ab74"
    sha256 cellar: :any,                 arm64_sequoia:  "5ea96ebb5b0af96ca5976f5c0a188c772eadc46fa52edb44cdb89f3d2e69436c"
    sha256 cellar: :any,                 arm64_sonoma:   "30d96fead1ad674156f1ca3121c2c5df27f3a2e42d226425ca6f83554628a86b"
    sha256 cellar: :any,                 arm64_ventura:  "883c11e84b2dcdd6ed46344697e8363a2c61e68d26aa6439d4684bc1a7abc76b"
    sha256 cellar: :any,                 arm64_monterey: "c8c154ece840edeeb4b4d0fe76383b60177ada3a525d96a124dc3fac80d9ae34"
    sha256 cellar: :any,                 arm64_big_sur:  "349ff7a34aacf021f8df3d129fa7e8897bd1b87a41d7df6b270fa98d73039ab4"
    sha256 cellar: :any,                 sonoma:         "117263ab5d0be7513bd9f5eebf3f32abfce63fcee8e5b3cfbd43d3325943a99b"
    sha256 cellar: :any,                 ventura:        "eae9333e11a79c651d8313e0b9c969c104a083edc3f6c835d484b10394f1f32b"
    sha256 cellar: :any,                 monterey:       "20e6d9ac347bc1903177aa5273e25ac2fd1f6dd56211e4170d46741ebdbd0b4d"
    sha256 cellar: :any,                 big_sur:        "12240dfe307818f58b11e495c81258979570e55640173382d3be77e39ee8dd0a"
    sha256 cellar: :any,                 catalina:       "b5a26e72c3d49e5b8b70432c11c93ffb392325c4a8a16cce2497b203bd23559d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0b06dc5dc420eec5a92256e31369688142112ce6c5ddf4b4bb07c638fe8e7f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf21846969fac2323ea2d8762b04c7f090bb0d9092c98636a853c50aaab49230"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  # Backport fix for CMake 4
  patch do
    url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/commit/5ae0333225130c1ec377e9cf10a60ad7c86c058d.diff"
    sha256 "2396f89a55a12e65120358502a450a6752dfa6ca4fc3f00462a0510909eb33db"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/tch1dn.f", "test/utils.f"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f", pkgshare/"utils.f",
                       "-fallow-argument-mismatch",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
