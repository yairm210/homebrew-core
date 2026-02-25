class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "68184e41706d77e409f05a598a87dacdf3cf227f18c028175e2bce8b284bdea4"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb1aea233d5290b68ece9eea3fd31675586b2605dadaa7037f4b9ab1a72bf26f"
    sha256 cellar: :any,                 arm64_sequoia: "f655f79f72630cbd72d17a0e655b520a92ae8758baa74d93d75a40ff5040d2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "230fe2322f4c8cc7cef85e1ed0498d4405c725e793fd375e4774ceaf2585e2c0"
    sha256 cellar: :any,                 sonoma:        "c8db8ebf3fa7797363e0f46e26a4de458f76130d7512e794b9e7dc78ec80ae88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bcbc6e7a0390a11a375772067fa935370bd81344f7619738180b2760201b253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1629b0f197520096e048911ae289bd77334b14eefbf1f50167990713b63024"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # PR ref: https://github.com/pachterlab/kallisto/pull/506
  # Fix error: no member named 'sz_link' in 'DataStorage<Unitig_data_t>'
  patch do
    url "https://github.com/pachterlab/kallisto/commit/a5caefb608611c48e102d63e91eafd3660d3e569.patch?full_index=1"
    sha256 "e29be49cc52a18f78b13b381f2d97cdf047ea45ba6b61b94caa54d46e195d0e2"
  end
  # Fix missing hdf5 libraries
  patch do
    url "https://github.com/pachterlab/kallisto/commit/e79245b1386d984849f2274fd2287a85682991bc.patch?full_index=1"
    sha256 "0a2e28de1bbe247842f5f6082a00ac60158ffe3d3264b639131d16b9c8c2e1a5"
  end

  def install
    # Fix to error: unsupported option '-mno-avx2'
    inreplace "ext/bifrost/CMakeLists.txt", "-mno-avx2", ""

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", "-DUSE_HDF5=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS

    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
