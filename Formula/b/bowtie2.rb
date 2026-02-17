class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "841a6a60111b690c11d1e123cb5c11560b4cd1502b5cee7e394fd50f83e74e13"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9b418a285f79ded12b965982e047b28c5bee357ce6eda671ee908352b3f3e8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee425308d905273c61af149c3f0d5f1e276464f67abcdf67598f34875bcf0e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc4584844cba19954860386b56c3e633f5a0363cff2a08b0a049bcc59c1aee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "88d4a0d2ce4eb91d0c1be922a007d7cb4b836875eaa816d37066b25456d117c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629ec739924219891200f50034c99d17b909bf01481ad12fc51fe89611d3539e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834853310b0293c535ac29a92672208cb43fb22f2bb9917855eec064787810a6"
  end

  uses_from_macos "perl"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "simde" => :build
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system bin/"bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_path_exists testpath/"lambda_virus.1.bt2", "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
