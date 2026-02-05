class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d18128d5c2340262665bf5d63cfdad60c9123c35263bc6386f8547f50d280232"
    sha256 cellar: :any,                 arm64_sequoia: "9699a0ea3a717a84f14121a83a87a7dadcb750efdf6b53113f12b071195062cd"
    sha256 cellar: :any,                 arm64_sonoma:  "c98ed0c1d16634ccedb273de756405518ed19b215ffc270d6f439d7c2ed3c1d0"
    sha256 cellar: :any,                 sonoma:        "2c37aeccd305f0c70f00c146cc590cc700244ffa5309f5f673320154d3e37dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "359690bc3c79939b2e520fd2dec9e00b2c7775df038d6b24ea81d28bf1cb4362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279b8bb50240191f28390ed15f4c081dad8e7e851ea442697681e5b32fb9aaf0"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
