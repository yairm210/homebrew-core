class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "cedd760e3faf61b03a40db75fcd304b46d60a17d3a5e868e6422162a6a522b47"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7e3ef73e130726949e4e4634d3bd7aa78d1fb22c5fd9bde34123417ced18b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1497b72cdebea582d06375aa7ececc525046644bf998556ca6079c059599aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ad4e0719c6e0989bde3418e81a4d351ff23e777a031f097366a26b9134614f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ff80dce20906e24e09a813db8d110535e3e6c7ea7bfdd140023ab14dfb3d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af70dcfdb57ed0d5da744ff2b4e436eda1a41d0c0280d0f173cd78b711393091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483d64fefe5df9f673614f9b122cd4326a3af4742780a03021ee3937cc1bce1f"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end
