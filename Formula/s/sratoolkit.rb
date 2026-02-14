class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.3.0.tar.gz"
    sha256 "3bfa26c5499a94d3b2a98eb65113bbb902f51dadef767c7c7247fc0175885a9a"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.3.0.tar.gz"
      sha256 "36b3467affd53bea794e3eeb5598619d820bc726dc68751a189181ac7973047d"

      livecheck do
        formula :parent
      end
    end

    # Backport fix for newer libxml2
    patch do
      url "https://github.com/ncbi/sra-tools/commit/e2b9d82b59c2636a1224995dbb7164c0b1391c77.patch?full_index=1"
      sha256 "47a5b9811ef4745ebce51a7c7ed794855131702d93e8272385d326ef9cd0c52f"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3915f52ef559a82d3b6947c64ea62793ce0089a29ba79ad032c87c602abc4ceb"
    sha256 cellar: :any,                 arm64_sequoia: "3f638492e68e21c284a4aeee221d5e169b1984a75adf1648fa33d8481dd354f9"
    sha256 cellar: :any,                 arm64_sonoma:  "5eb9c8506a1ad99e5f5b929314e807018e7e0ad2562cee2bfe55f6fe3a9f49f7"
    sha256 cellar: :any,                 arm64_ventura: "111636d770e9da3b1b0cd652f0cb46b7fb48e283e553859fb04aebc6078d7b3f"
    sha256 cellar: :any,                 sonoma:        "f6b0a3c7e7ea88755d2cb2f33a58c8b93565f8ed8024f9b3a3709425775cbe8b"
    sha256 cellar: :any,                 ventura:       "4d6f5a48ea2ce178703d4ec93bbaa589a3e3c86751a9a8eaf95dd6faac75590a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244c56dd90cfa2a51e4c55065a58dfee0f39a82a06f5547815d412a339111965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580d70086da44a3bab3152314fe4af79a710f04dc140bb032c13ee26b5323211"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "libxml2"

  def install
    odie "ncbi-vdb resource needs to be updated" if build.stable? && version != resource("ncbi-vdb").version

    (buildpath/"ncbi-vdb-source").install resource("ncbi-vdb")

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}/ngs/ngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}/ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}/ncbi-vdb-build/lib",
                    "-DVDB_INCDIR=#{buildpath}/ncbi-vdb-source/interfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    rm_r(bin/"ncbi")
  end

  test do
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
